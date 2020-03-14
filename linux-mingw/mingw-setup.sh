#!/usr/bin/bash -e
# install pefile and lief
pip3 install pefile lief

QT_SDK_REPO='https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/'

# navigate to the URL above to find out the following parameters
QT_RELEASE='5.14.2'
QT_RL='0' # usually zero
QT_BUILD='202002242320'
QT_COMPONENTS=('qtbase' 'qttranslations' 'qtimageformats' 'qtwinextras' 'qtmultimedia' 'qttools')


TARGET_DIR='mingw64/x86_64-w64-mingw32/lib/'

# SDL2
SDL2_VER='2.0.12'
wget "https://www.libsdl.org/release/SDL2-devel-${SDL2_VER}-mingw.tar.gz"
tar -zxf "SDL2-devel-${SDL2_VER}-mingw.tar.gz"
cd SDL2-${SDL2_VER}/
make install-package arch=x86_64-w64-mingw32 prefix=/usr/x86_64-w64-mingw32;
cd ..

# ffmpeg
FFMPEG_VER='4.3.1-2020-11-08'
echo "Downloading ffmpeg ..."
wget -q -c "https://github.com/GyanD/codexffmpeg/releases/download/${FFMPEG_VER}/ffmpeg-${FFMPEG_VER}-full_build-shared.7z"
7z x "ffmpeg-${FFMPEG_VER}-full_build-shared.7z" > /dev/null

echo "Copying ffmpeg ${FFMPEG_VER} files to sysroot..."
cp -v "ffmpeg-${FFMPEG_VER}-full_build-shared"/bin/*.dll /usr/x86_64-w64-mingw32/lib/
cp -vr "ffmpeg-${FFMPEG_VER}-full_build-shared"/include /usr/x86_64-w64-mingw32/
cp -v "ffmpeg-${FFMPEG_VER}-full_build-shared"/lib/*.{a,def} /usr/x86_64-w64-mingw32/lib/

# Qt
QT_VERSION="${QT_RELEASE//./}"
for i in "${QT_COMPONENTS[@]}"; do
  echo "Downloading Qt prebuilt binary (${i})..."
  wget -q "${QT_SDK_REPO}/qt5_${QT_VERSION}/qt.qt5.${QT_VERSION}.win64_mingw73/${QT_RELEASE}-${QT_RL}-${QT_BUILD}${i}-Windows-Windows_10-Mingw73-Windows-Windows_10-X86_64.7z"
done

mkdir -p qt5 && cd qt5
for i in ../*.7z; do
  echo "Extracting ${i}..."
  7z x "${i}"
done
cp -r "${QT_RELEASE}/mingw73_64"/* '/usr/x86_64-w64-mingw32/'
# fix the library paths
echo 'Creating symlinks for libraries...'
mkdir -p '/usr/x86_64-w64-mingw32/lib/qt5'
for i in 'mkspecs' 'phrasebooks' 'plugins' 'qml' 'translations'; do
  ln -sv "/usr/x86_64-w64-mingw32/$i" "/usr/x86_64-w64-mingw32/lib/qt5/$i"
done
# replace
echo 'Replacing Qt Tools with native binaries...'
for i in 'moc' 'qdbuscpp2xml' 'qdbusxml2cpp' 'qlalr' 'qmake' 'rcc' 'uic' 'lconvert' 'lrelease' 'lupdate'; do
  rm -f "/usr/x86_64-w64-mingw32/bin/$i.exe"
  ln -sv "$(which $i)" "/usr/x86_64-w64-mingw32/bin/$i"
done
# patch
echo 'Patching cmake files to use native tools...'
for i in $(grep -rl '\.exe' /usr/x86_64-w64-mingw32/lib/cmake/); do
  echo "[-] Patching $i..."
  sed -i 's/\.exe//g' "$i"
done

cd ..

# remove debug symbols, we don't need them in a release build
echo 'Removing debug symbols...'
find '/usr/x86_64-w64-mingw32/' -name '*.debug' -delete
# remove the directory
ABS_PATH="$(readlink -f $0)"
rm -rf "$(dirname ${ABS_PATH})"
