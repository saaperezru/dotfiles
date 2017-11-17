mkdir $1
cp -r ~/.proto/java-gradle/* $1/
rm $1/start.sh
cd $1
./gradlew clean eclipse build
