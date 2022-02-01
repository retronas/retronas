FROM debian:stable-slim

# Install packages
RUN \
    apt-get update \
    && apt-get install -y \
        ansible \
    && rm -rf /var/lib/apt/lists/*

# Create user PI
RUN useradd pi --uid 1000 

# add files to container
COPY . /opt/retronas

# Create a volume 
## /!\ you may want to use a bind mount to the host filesystem instead of the volume
VOLUME ["/data/retronas"]

# run the main program
CMD [ "bash", "/opt/retronas/docker/run.sh" ]
