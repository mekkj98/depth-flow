# Runpod Implementation of DepthFlow

This is a runpod implementation of the DepthFlow library.

## Setup

1. Fork this repository into your own github account.

2. Go to your runpod account and create a new endpoint. Click on the "Github Repo" button. Connect your github account if necessary.

Runpod Create Endpoint URL:
https://www.runpod.io/console/serverless/new-endpoint

I used a 24GB GPU for this endpoint. You can use a smaller GPU if you want, but it will be slower.

It takes about 5 minutes to build.

## License

MIT



## Testing

The repo includes a test script that you can use to test the endpoint. Change the `API_KEY`, `ENDPOINT_ID`, and `IMAGE_URL` to your own.

```bash
./test-df.sh
```

