#!/bin/bash

JAVA_HOME=/usr/lib64/jvm/jre-11-openjdk/
ANDROID_HOME=~/tools/Android/Sdk/
#export DEX_PREOPT_DEFAULT=nostripping

$JAVA_HOME/bin/javac -source 9 -target 9 -d ./obj -classpath $ANDROID_HOME/platforms/android-30/android.jar -sourcepath ./src ./src/ru/samsung/itschool/book/HelloSDK.java ./src/ru/samsung/itschool/book/R.java

$ANDROID_HOME/build-tools/30.0.0/aapt package -v -f -m  -S ./res -J ./src -M ./AndroidManifest.xml -I $ANDROID_HOME/platforms/android-30/android.jar

mkdir bin

$ANDROID_HOME/build-tools/30.0.0/dx --dex --verbose --output=./bin/classes.dex ./obj

$ANDROID_HOME/build-tools/30.0.0/aapt package -v -f -M ./AndroidManifest.xml -S ./res -I  $ANDROID_HOME/platforms/android-30/android.jar -F ./bin/app.unsigned.apk ./bin/
$ANDROID_HOME/build-tools/30.0.0/aapt add ./bin/app.unsigned.apk ./bin/classes.dex

$JAVA_HOME/bin/keytool -genkeypair -validity 1000 -dname "CN=Manual compile example,O=Samsung It Academy,C=RU" -keystore ./ToyKey.keystore -storepass qwerty -keypass qwerty -alias MyKey -keyalg RSA -v

$JAVA_HOME/bin/jarsigner -verbose -keystore ./ToyKey.keystore -storepass qwerty -keypass qwerty -signedjar ./bin/app.signed.apk ./bin/app.unsigned.apk MyKey

$ANDROID_HOME/build-tools/30.0.0/zipalign -v -f 4 ./bin/app.signed.apk ./bin/app.apk


$ANDROID_HOME/platform-tools/adb install -r ./bin/app.apk


$ANDROID_HOME/platform-tools/adb shell am start -n ru.samsung.itschool.book/ru.samsung.itschool.book.HelloSDK

