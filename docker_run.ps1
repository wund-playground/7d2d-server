#you need to allow docker access to the shared drive the git repo is on, this is done through the GUI

#run build first
.\docker_build.ps1

#get pwd.. because Get-Location doesn't work
$pwd = (Get-Location).tostring().Replace('\','/')

#start command
docker run -p 26905:26905/tcp -p 26905:26905/udp -p 26906:26906/udp -p 26907:26907/udp -p 26908:26908/udp -p 27016:27016/udp -p 8085:8085/tcp -p 8086:8086/tcp -e SEVEN_DAYS_TO_DIE_UPDATE_CHECKING="1" -v "./7dtd_data/game:/steamcmd/7dtd" -v "./7dtd_data/data:/app/.local/share/7DaysToDie"  cryptton2004/7dtd-server-new -d