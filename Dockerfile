FROM cryptton2004/steamcmd

# Fixes apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
    xvfb \
    telnet \
    expect && \
    rm -rf /var/lib/apt/lists/*

# Create the volume directories
RUN mkdir -p /steamcmd/7dtd /app/.local/share/7DaysToDie
RUN mkdir -p /steamcmd/7dtd/mods
# Setup scheduling support
ADD scheduler_app/ /app/scheduler_app/
WORKDIR /app/scheduler_app
RUN npm install
WORKDIR /

# Add the steamcmd installation script
ADD install.txt /app/install.txt

# Copy scripts
ADD csmm.sh /app/csmm.sh
ADD start_7dtd.sh /app/start.sh
ADD shutdown.sh /app/shutdown.sh
ADD update_check.sh /app/update_check.sh

# Fix permissions
RUN chown -R 1000:1000 \
    /steamcmd \
    /app \
	/steamcmd/7dtd/mods

# Run as a non-root user by default
ENV PGID 1000
ENV PUID 1000

# Expose necessary ports
EXPOSE 26905/tcp
EXPOSE 26905/udp
EXPOSE 26906/udp
EXPOSE 26906/udp
EXPOSE 27016/udp
EXPOSE 8085/tcp
EXPOSE 8086/tcp

# Setup default environment variables for the server
ENV SEVEN_DAYS_TO_DIE_SERVER_STARTUP_ARGUMENTS "-quit -batchmode -nographics -dedicated"
ENV SEVEN_DAYS_TO_DIE_CONFIG_FILE "/app/.local/share/7DaysToDie/serverconfig.xml"
ENV SEVEN_DAYS_TO_DIE_TELNET_PORT ${SEVEN_DAYS_TO_DIE_TELNET_PORT}
ENV SEVEN_DAYS_TO_DIE_SERVER_PASSWORD ${SEVEN_DAYS_TO_DIE_SERVER_PASSWORD}
ENV SEVEN_DAYS_TO_DIE_TELNET_PASSWORD ${SEVEN_DAYS_TO_DIE_TELNET_PASSWORD}
ENV SEVEN_DAYS_TO_DIE_BRANCH "public"
ENV SEVEN_DAYS_TO_DIE_START_MODE "2"
ENV SEVEN_DAYS_TO_DIE_UPDATE_CHECKING "0"

# Define directories to take ownership of
ENV CHOWN_DIRS "/app,/steamcmd"

USER docker

# Expose the volumes
VOLUME [ "/steamcmd/7dtd", "/app/.local/share/7DaysToDie" ]

# Start the server
CMD [ "bash", "/app/start.sh" ]
