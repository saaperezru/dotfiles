mkdir -p $1
mkdir -p $1/dist
cp -r ~/.proto/nix-rmarkdown/* $1/
rm $1/start.sh
cd $1
mkdir $1/dist
npm install
npm start
