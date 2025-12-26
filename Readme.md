# Commands
``` bash
docker build -t ivr-server-gemini .
docker exec -it ivr-server-gemini asterisk -r


# Build the image
docker build -t ivr-asterisk .

# Run with host networking (easiest for SIP/RTP testing)
docker run -it --net=host --name my-ivr ivr-asterisk
```