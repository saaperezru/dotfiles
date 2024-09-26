mkdir $1
cp -r ~/.proto/nix-rmarkdown/* $1/
rm $1/start.sh
cd $1
mkdir $1/dist
npm install
npm start
