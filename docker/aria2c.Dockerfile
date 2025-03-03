# Start with the lightweight Alpine base image
FROM alpine:latest

# Set maintainer information
LABEL maintainer="jorge.s.cuesta@gmail.com"

# Update Alpine package manager and install aria2
RUN apk update && apk add --no-cache aria2 tar zstd gzip

# Create a directory for downloads
WORKDIR /downloads

# Expose a volume for downloads (optional)
VOLUME /downloads

# Set 'aria2c' as default entrypoint
ENTRYPOINT ["aria2c"]

# By default show help if no additional args provided
CMD ["--help"]
