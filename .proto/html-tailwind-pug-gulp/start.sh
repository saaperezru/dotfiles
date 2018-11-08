mkdir $1
cp -r ~/.proto/html-tailwind-pug-gulp/* $1/
rm $1/start.sh
cd $1
npm install
