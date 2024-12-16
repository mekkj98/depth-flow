from DepthFlow import DepthScene
import runpod
import base64
import os

def handler(event):
    input = event['input']
    image = input.get('image')

    intensity=1.5
    reverse=True
    fps=30
    time=5
    # Create a DepthScene instance
    scene = DepthScene()

    # Set dolly parameters
    scene.dolly(intensity=intensity, reverse=reverse)

    # Provide the image input
    scene.input(image=image)

    # Set the output path
    output_path = "video.mp4"

    # Run DepthFlow main method
    scene.main(output=output_path, fps=fps, time=time)

    # Read the video file and convert to base64
    with open(output_path, "rb") as video_file:
        video_base64 = base64.b64encode(video_file.read()).decode('utf-8')

    # Delete the video file
    os.remove(output_path)

    return {
        "video_base64": video_base64
    }

if __name__ == '__main__':
    runpod.serverless.start({'handler': handler})