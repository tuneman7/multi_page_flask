

#check viritual environments:


python3 -m venv testing > /dev/null
export python_venv=$?
echo "$python_venv"
rm -rf testing
npm version > /dev/null
export npm_present=$?
echo "$npm_present"


all_dependencies=1


  if [ "$npm_present" -ne 0 ]; then
    echo "NPM is not present."
    export all_dependencies=0
  fi

  if [ "$python_venv" -ne 0 ]; then
    echo "Python Virtual Environments are not installed."
    export all_dependencies=0
  fi


#     bozo
#     bozo_present=$?

#   if [ "$bozo_present" -ne 0 ]; then
#     echo "Bozo not installed."
#     export all_dependencies=0
#   fi  

rm output.txt