echo "Старт"
# $1 - project_location
# $2 - app_name
# $3 - key_folder
# $4 - apk_folder
key_app_name="${2//' '}"
path_to_bundletool="/home/user/Programs"
echo "Подготовка apks"
java -jar $path_to_bundletool/bundletool-all-1.7.0.jar build-apks --bundle=$1/platforms/android/app/release/app-release.aab --output=$4/$key_app_name.apks --ks=$3/$key_app_name.jks --ks-pass=pass:dhkelfh --ks-key-alias=aapbuild_alias --key-pass=pass:dhkelfh
echo "Установка на телефон"
java -jar $path_to_bundletool/bundletool-all-1.7.0.jar install-apks --apks=$4/$key_app_name.apks
echo "Установка ЗАВЕРШЕНА"
