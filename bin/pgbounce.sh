#!/bin/bash
docker-compose down
docker volume rm $(docker volume ls -q)
docker-compose up --build -d
