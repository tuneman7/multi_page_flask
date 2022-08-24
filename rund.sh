#!/bin/bash

. check_deps.sh > output.txt


clear

echo "**********************************"
echo "* U.C. Berkeley MIDS W255        *"
echo "* Fall 2022                      *"
echo "* Student: Don Irwin             *"
echo "**********************************"

echo "**********************************"
echo "* CHECKING ALL DEPENDENCIES      *"
echo "* Python Virtual Environments    *"
echo "* Npm                            *"
echo "**********************************"


  if [ "$all_dependencies" -ne 1 ]; then

        echo "**********************************"
        echo "* Not all depdencies were met    *"
        echo "* Please install dependencies    *"
        echo "* and try again.                 *"
        echo "**********************************"


        if [ "$python_venv" -ne 0 ]; then
            echo "Python Virtual Environments are not installed."
            export all_dependencies=0
        fi

        if [ "$npm_present" -ne 0 ]; then
            echo "NPM is not present."
            echo "Visit the NPM install site:"
            echo "https://docs.npmjs.com/downloading-and-installing-node-js-and-npm"
            export all_dependencies=0
        fi


        echo "**********************************"
        echo "**********************************"
        return
  fi


# #Set Up the Virtual Environment
# #dependencies
# . setup_env_dep.sh
# . setup_venv.sh



# echo "*********************************"
# echo "*  KILLING ANY PROCESS          *"
# echo "*  Using Port 5000              *"
# echo "*                               *"
# echo "*********************************"

# pid_to_kill=$(lsof -t -i :5000 -s TCP:LISTEN)

# sudo kill ${pid_to_kill}

# flask run --debugger & > flask_output.txt

# echo "*********************************"
# echo "*                               *"
# echo "*        WAITING. ....          *"
# echo "*        API not ready          *"
# echo "*                               *"
# echo "*********************************"


# finished=false
# while ! $finished; do
#     health_status=$(curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://127.0.0.1:5000/flask/hello")
#     if [ $health_status == "200" ]; then
#         finished=true
#         echo "*********************************"
#         echo "*                               *"
#         echo "*        API is ready           *"
#         echo "*                               *"
#         echo "*********************************"
#     else
#         finished=false
#     fi
# done
# echo""
# echo""



# #Now create the front-end
# rm -rf frontend
# mkdir frontend
# . create_react_app.sh

# cd ./frontend
# cp ./../npm_build.sh ./

echo "*********************************"
echo "*  KILLING ANY PROCESS          *"
echo "*  Using Port 3000              *"
echo "*                               *"
echo "*********************************"

pid_to_kill=$(lsof -t -i :3000 -s TCP:LISTEN)

sudo kill ${pid_to_kill}

cd ./react-multi-page-website/
npm install
#. npm_build.sh & > npm_output.txt
npm run build 

cd ./../


IMAGE_NAME=react_in_docker
APP_NAME=react_in_docker
DOCKER_FILE=Dockerfile.react_in_docker
NET_NAME=test


echo "docker network rm ${NET_NAME}"
docker network rm ${NET_NAME}

echo "docker network create rm ${NET_NAME} "
docker network create ${NET_NAME} 

echo "docker stop ${APP_NAME}"
docker stop ${APP_NAME}
echo "docker rm ${APP_NAME}"
docker rm ${APP_NAME}


while true; do

        echo "*********************************"
        echo "*                               *"
        echo "* Do you wish to build the      *"
        echo "* docker image?                 *"
        echo "*   Press \"B\" build             *"
        echo "*   Press \"N\" use existing      *"
        echo "*   image                       *"        
        echo "*                               *"        
        echo "*********************************"


    read -p "Build or not? [B/N]:" bn
    case $bn in
        [Nn]* )  break;;
        [Bb]* ) docker build -t ${IMAGE_NAME} -f ${DOCKER_FILE} . ; break;;
        * ) echo "Please answer \"b\" or \"n\".";;
    esac
done        



echo "run -d --net ${NET_NAME} --name ${APP_NAME} -p 8000:8000 ${IMAGE_NAME}"
#docker run -d --net ${NET_NAME} --name ${APP_NAME} -p 3000:3000 ${IMAGE_NAME} sleep infinity

docker run -d --net ${NET_NAME} --name ${APP_NAME} -p 3000:3000 ${IMAGE_NAME} #sleep infinity

echo "*********************************"
echo "*                               *"
echo "*        WAITING. ....          *"
echo "*        React not ready        *"
echo "*                               *"
echo "*********************************"


finished=false
while ! $finished; do
    health_status=$(curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://127.0.0.1:3000")
    if [ $health_status == "200" ]; then
        finished=true
        echo "*********************************"
        echo "*                               *"
        echo "*        react is ready         *"
        echo "*                               *"
        echo "*********************************"
    else
        finished=false
    fi
done
echo""
echo""



echo "*********************************"
echo "*                               *"
echo "*        Press Enter to         *"
echo "*        End Application        *"
echo "*********************************"

read -p "Press Enter to Terminate Application:" 

echo "docker stop ${APP_NAME}"
docker stop ${APP_NAME}
echo "docker rm ${APP_NAME}"
docker rm ${APP_NAME}

echo "docker network rm ${NET_NAME}"
docker network rm ${NET_NAME}


echo "*********************************"
echo "*  KILLING ANY PROCESS          *"
echo "*  Using Port 5000              *"
echo "*                               *"
echo "*********************************"

pid_to_kill=$(lsof -t -i :5000 -s TCP:LISTEN)

sudo kill ${pid_to_kill}

echo "*********************************"
echo "*  KILLING ANY PROCESS          *"
echo "*  Using Port 3000              *"
echo "*                               *"
echo "*********************************"

pid_to_kill=$(lsof -t -i :3000 -s TCP:LISTEN)

sudo kill ${pid_to_kill}

sudo kill -INT "$react_pid"

#deactivate

. check_listeners.sh

echo -ne '\n' | echo "*********************************"
echo "*                               *"
echo "*  PROGRAM COMPLETE             *"
echo "*                               *"
echo "*********************************"
