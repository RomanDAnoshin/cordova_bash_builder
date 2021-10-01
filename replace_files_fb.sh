echo "Старт"
# $1 - project_location
# $2 - facebook_code_location
cp -vf $2/ConnectPlugin.java $1/platforms/android/app/src/main/java/org/apache/cordova/facebook/ConnectPlugin.java
cp -vf $2/facebook-native.js $1/platforms/android/platform_www/plugins/cordova-plugin-facebook4/www/facebook-native.js
echo "Замена файлов ЗАВЕРШЕНА"
