
#!/bin/bash

API_KEY="rpa_YOUR_API_KEY"
ENDPOINT_ID="YOUR_ENDPOINT_ID"
IMAGE_URL="https://example.com/image.png"

# Make the initial curl request and store the response
response=$(curl -s -X POST "https://api.runpod.ai/v2/${ENDPOINT_ID}/run" \
  -H "Content-Type: application/json" \
  -H "Authorization: ${API_KEY}" \
  -d "{
    \"input\": {
      \"image\": \"${IMAGE_URL}\",
      \"animation_type\": \"Dolly\",
      \"animation_params\": {
        \"loop\": false,
        \"intensity\": 1.5,
        \"reverse\": false,
        \"depth\": 1.5
      }
    }
  }")

# Extract the job ID
job_id=$(echo $response | jq -r '.id')
echo "Job ID: $job_id"

# Check status every 5 seconds
while true; do
    status_response=$(curl -s "https://api.runpod.ai/v2/${ENDPOINT_ID}/status/${job_id}" \
        -H "Authorization: ${API_KEY}")
    
    status=$(echo $status_response | jq -r '.status')
    echo "Current status: $status"
    
    if [ "$status" = "COMPLETED" ]; then
        echo "Job completed successfully!"
        # Extract the video_base64 content using jq
        video_base64=$(echo $status_response | jq -r '.output.video_base64')
        
        # Create timestamp for filename
        timestamp=$(date +%s)
        
        # Create tests directory if it doesn't exist
        mkdir -p tests
        
        # Decode base64 and save as mp4
        echo $video_base64 | base64 -d > "tests/${timestamp}.mp4"
        
        echo "Video saved as tests/${timestamp}.mp4"
        break
    elif [ "$status" = "FAILED" ]; then
        echo "Job failed!"
        error_message=$(echo $status_response | jq -r '.error')
        echo "Error: $error_message"
        exit 1
    fi
    
    sleep 5
done