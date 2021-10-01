echo "Старт"
# $1 - path_to_bundletool
# $2 - apks_folder
# $3 - apks_name

java -jar $1/bundletool-all-1.7.0.jar install-apks --apks=$2/$3.apks
echo "Установка на телефон завершена"
