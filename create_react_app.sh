
cd frontend
rm -rf .eslintcache
rm -rf build/
rm package-lock.json
rm package.json 
rm -rf public
rm -rf src
npx create-react-app .
npm install axios
cp -f ./../App.js ./src/
cd ./../

