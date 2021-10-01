#!/bin/bash
echo "Старт"
# $1 - project_location
# $2 - app_name
# $3 - package
# $4 - version
# $5 - facebook_code_location
# $6 - plug_location
# $7 - mipmap_location
# $8 - key_folder
# $9 - apk_folder

# Перейти в папку проекта
cd $1

# Работа с config файлом
# пакет, версия, xmlns:android, имя приложения, minSdk, targetSdk, edit-config 
echo ""
echo "Обработка config файла"

old_app_name="$(sed -n '3p' < config.xml)"
old_app_name="${old_app_name//<name>}"
old_app_name="${old_app_name//'</name>'}"
old_app_name="${old_app_name//' '}"
sed -i "s/$old_app_name/$2/" "config.xml"

old_package="$(sed -n '2p' < config.xml)"
old_package=($old_package)
old_package=${old_package[1]}
old_package="${old_package//id=\"}"
old_package="${old_package//\"}"
sed -i "s/$old_package/$3/" "config.xml"

old_version="$(sed -n '2p' < config.xml)"
old_version=($old_version)
old_version=${old_version[2]}
old_version="${old_version//version=\"}"
old_version="${old_version//\"}"
new_version=${4:0:1}.${4:1:1}.${4:2:1}
sed -i "s/$old_version/$new_version/" "config.xml"
echo "Обработка config файла ЗАВЕРШЕНА"

# Переустановить платформу
echo ""
echo "Переустановка платформы"
cordova platform remove android
cordova platform add android
echo "Переустановка платформы ЗАВЕРШЕНА"

# Заменить код фейсбук
echo ""
echo "Замена кода плагина фейсбук" 
cp -vf $5/ConnectPlugin.java $1/platforms/android/app/src/main/java/org/apache/cordova/facebook/ConnectPlugin.java
cp -vf $5/facebook-native.js $1/platforms/android/platform_www/plugins/cordova-plugin-facebook4/www/facebook-native.js
echo "Замена кода плагина фейсбук ЗАВЕРШЕНА"

# Заменить юрл-схему
echo ""
echo "Замена юрл-схемы"

if grep -Fxq "URL_SCHEME" $1/plugins/fetch.json
then 
cordova plugin remove cordova-plugin-customurlscheme --variable URL_SCHEME=randomtext
fi
new_url_scheme=${3:4}
new_url_scheme="${new_url_scheme//.}"
cordova plugin add cordova-plugin-customurlscheme --variable URL_SCHEME=$new_url_scheme
echo "Замена юрл-схемы ЗАВЕРШЕНА"

# Добавить заглушку
echo ""
echo "Добавление заглушки"
cd $6
mv index.html game.html
cp -vrf $6/. $1/www
echo "Добавление заглушки ЗАВЕРШЕНО"

# Добавить мипмапы
echo ""
echo "Добавление мипмапов"
cp -vrf $7/. $1/platforms/android/app/src/main/res
cp -vf $1/platforms/android/app/src/main/res/mipmap-hdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-hdpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-hdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-ldpi/ic_launcher.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-hdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-ldpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-mdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-mdpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-xhdpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-xxhdpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-xxxhdpi-v26/ic_launcher_foreground.png
echo "Добавление мипмапов ЗАВЕРШЕНО"

# Добавить прелоадер
#echo ""
#echo "Добавие прелоадера"
#echo "Добавие прелоадера ЗАВЕРШЕНО"
echo "Ожидание добавления прелоадера и изменений в заглушку"
read input

# Сбока проекта
echo ""
echo "Сбока проекта"
cd $1
cordova build --release
echo "Сбока проекта ЗАВЕРШЕНА"

# Создать ключ
echo ""
echo "Создание ключа"
key_name="${2//' '}"
keytool -genkey -v -keystore $8/$key_name.keystore -alias alias -keyalg RSA -keysize 2048 -validity 10000 -storepass dhkelfh -keypass dhkelfh -dname "CN=, OU=, O=, L=, S=, C="
echo "Создание ключа ЗАВЕРШЕНО"

# Подписать апк
echo ""
echo "Подпись апк"
jarsigner -verbose -keystore $8/$key_name.keystore $1/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk alias -storepass dhkelfh
release_apk_name=$key_name"_"$4
zipalign -v 4 $1/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk $9/$release_apk_name.apk
echo "Подпись апк ЗАВЕРШЕНА"
