#! /bin/bash

docker compose down -v
docker ps -qa | xargs docker rm -f
docker images -qa | xargs docker rmi -f
sudo docker system prune -f --volumes
docker volume prune -f

sudo rm -rf /etc/graylog/*

echo "удалена директория грейлог"

docker volume rm \
  server_mongodb_data \
  server_mongodb_config \
  server_graylog-datanode \
  server_graylog_data


