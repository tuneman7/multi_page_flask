#!/bin/bash


echo "*********************************"
echo "Look at pids using 3000 or 5000 with listeners"
echo "*********************************"

lsof -t -i :5000 -s TCP:LISTEN
lsof -t -i :3000 -s TCP:LISTEN
