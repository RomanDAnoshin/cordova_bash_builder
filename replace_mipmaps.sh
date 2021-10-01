echo "Старт"
# $1 - project_location
# $2 - mipmap_location
echo "Замена мипмапов"
cp -vrf $2/. $1/platforms/android/app/src/main/res
cp -vf $1/platforms/android/app/src/main/res/mipmap-hdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-hdpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-hdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-ldpi/ic_launcher.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-hdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-ldpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-mdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-mdpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-xhdpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-xxhdpi-v26/ic_launcher_foreground.png
cp -vf $1/platforms/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png $1/platforms/android/app/src/main/res/mipmap-xxxhdpi-v26/ic_launcher_foreground.png
echo "Замена мипмапов ЗАВЕРШЕНО"
