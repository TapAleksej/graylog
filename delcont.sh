#! /bin/bash

docker compose down -v
docker ps -qa | xargs docker rm -f
docker images -qa | xargs docker rmi -f
sudo docker system prune -f --volumes
docker volume prune -f