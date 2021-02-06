#!/bin/bash

./docker_build.sh

# Run the server
docker run -p 26905:26905/tcp -p 26905:26905/udp -p 26906:26906/udp -p 26907:26907/udp -p 26908:26908/udp -p 27016:27016/udp -p 8085:8085/tcp -p 8086:8086/tcp -e SEVEN_DAYS_TO_DIE_UPDATE_CHECKING="1" -v $(pwd)/7dtd_data/game:/steamcmd/7dtd -v $(pwd)/7dtd_data/data:/app/.local/share/7DaysToDie --name 7dtd-server-new -it --rm cryptton2004/7dtd-server-new -d