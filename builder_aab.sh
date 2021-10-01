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
path_to_bundletool="/home/user/Programs"

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

# Сборка AAB
echo ""
echo "Сборка AAB"
key_app_name="${2//' '}"
echo $key_app_name
echo "1. Открытие проекта (platforms/android) в Android Studio"
echo "2. Build -> Generate Signed Bundle / APK..."
echo "2.1. Android App Bundle -> Next"
echo "2.2. Key store: Create new... -> Next"
echo "3. Релиз апк будет в platforms/android/app/release"
echo "Ожидание..."
read input
cp -vf $1/platforms/android/app/release/app-release.aab $9/$key_app_name.aab
echo "AAB файл создан"

# Тестирование
echo ""
echo "Подготовка apks"
java -jar $path_to_bundletool/bundletool-all-1.7.0.jar build-apks --bundle=$1/platforms/android/app/release/app-release.aab --output=$9/$key_app_name.apks --ks=$8/$key_app_name.jks --ks-pass=pass:dhkelfh --ks-key-alias=aapbuild_alias --key-pass=pass:dhkelfh
echo "Установка на телефон"
java -jar $path_to_bundletool/bundletool-all-1.7.0.jar install-apks --apks=$9/$key_app_name.apks
