# Commands
``` bash
docker build -t ivr-server-gemini .
docker exec -it ivr-server-gemini asterisk -r


# Build the image
docker build -t ivr-asterisk .
docker build -t imshaopeng/ivr-asterisk .

# Run with host networking (easiest for SIP/RTP testing)
docker run -it --net=host --name my-ivr ivr-asterisk
```

# Docker repository

[ivr-server](https://github.com/shaopengwu/ivr-server-perl-asterisk.git)

# Verification
``` bash
docker build -t imshaopeng/ivr-server .
docker push imshaopeng/ivr-server
```