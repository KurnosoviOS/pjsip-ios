#!/bin/sh

# see http://stackoverflow.com/a/3915420/318790

FOLDER_PJSIP="pjsip-include"

function realpath { echo $(cd $(dirname "$1"); pwd)/$(basename "$1"); }

BUILD_DIR=$(realpath "build")
if [ ! -d ${BUILD_DIR} ]; then
    mkdir ${BUILD_DIR}
fi

OPTIMIZE_FLAG="-O2" # https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
# OPTIMIZE_FLAG="-O0" # 0 for debug

DEBUG_FLAGS="" # https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
#DEBUG_FLAGS="-g -DDEBUG -O0 -glldb" # for debug symbols

PJSIP_URL="http://www.pjsip.org/release/2.7.1/pjproject-2.7.1.tar.bz2"
PJSIP_ARCHIVE=${BUILD_DIR}/`basename ${PJSIP_URL}`


LOOP_ARCHS_URL="https://raw.githubusercontent.com/x2on/OpenSSL-for-iPhone/master/scripts/build-loop-archs.sh"
LOOP_TARGETS_URL="https://raw.githubusercontent.com/x2on/OpenSSL-for-iPhone/master/scripts/build-loop-targets.sh"

OPENSSL_URL="https://raw.githubusercontent.com/x2on/OpenSSL-for-iPhone/master/build-libssl.sh"

OPENSSL_DIR=${BUILD_DIR}/openssl
OPENSSL_SH=${OPENSSL_DIR}/`basename ${OPENSSL_DIR}`

OPENH264_DIR=$(realpath "openh264")

copy_libs () {
    DST=${1}

    if [ -d pjlib/lib-${DST}/ ]; then
        rm -rf pjlib/lib-${DST}/
    fi
    if [ ! -d pjlib/lib-${DST}/ ]; then
        mkdir pjlib/lib-${DST}/
    fi
    cp pjlib/lib/libpj-${DST}-apple-darwin_ios.a pjlib/lib-${DST}/libpj-${DST}-apple-darwin_ios.a

    if [ -d pjlib-util/lib-${DST}/ ]; then
        rm -rf pjlib-util/lib-${DST}/
    fi
    if [ ! -d pjlib-util/lib-${DST}/ ]; then
        mkdir pjlib-util/lib-${DST}/
    fi
    cp pjlib-util/lib/libpjlib-util-${DST}-apple-darwin_ios.a pjlib-util/lib-${DST}/libpjlib-util-${DST}-apple-darwin_ios.a

    if [ -d pjmedia/lib-${DST}/ ]; then
        rm -rf pjmedia/lib-${DST}/
    fi
    if [ ! -d pjmedia/lib-${DST}/ ]; then
        mkdir pjmedia/lib-${DST}/
    fi
    cp pjmedia/lib/libpjmedia-${DST}-apple-darwin_ios.a pjmedia/lib-${DST}/libpjmedia-${DST}-apple-darwin_ios.a
    cp pjmedia/lib/libpjmedia-audiodev-${DST}-apple-darwin_ios.a pjmedia/lib-${DST}/libpjmedia-audiodev-${DST}-apple-darwin_ios.a
    cp pjmedia/lib/libpjmedia-codec-${DST}-apple-darwin_ios.a pjmedia/lib-${DST}/libpjmedia-codec-${DST}-apple-darwin_ios.a
    cp pjmedia/lib/libpjmedia-videodev-${DST}-apple-darwin_ios.a pjmedia/lib-${DST}/libpjmedia-videodev-${DST}-apple-darwin_ios.a
    cp pjmedia/lib/libpjsdp-${DST}-apple-darwin_ios.a pjmedia/lib-${DST}/libpjsdp-${DST}-apple-darwin_ios.a

    if [ -d pjnath/lib-${DST}/ ]; then
        rm -rf pjnath/lib-${DST}/
    fi
    if [ ! -d pjnath/lib-${DST}/ ]; then
        mkdir pjnath/lib-${DST}/
    fi
    cp pjnath/lib/libpjnath-${DST}-apple-darwin_ios.a pjnath/lib-${DST}/libpjnath-${DST}-apple-darwin_ios.a

    if [ -d pjsip/lib-${DST}/ ]; then
        rm -rf pjsip/lib-${DST}/
    fi
    if [ ! -d pjsip/lib-${DST}/ ]; then
        mkdir pjsip/lib-${DST}/
    fi
    cp pjsip/lib/libpjsip-${DST}-apple-darwin_ios.a pjsip/lib-${DST}/libpjsip-${DST}-apple-darwin_ios.a
    cp pjsip/lib/libpjsip-simple-${DST}-apple-darwin_ios.a pjsip/lib-${DST}/libpjsip-simple-${DST}-apple-darwin_ios.a
    cp pjsip/lib/libpjsip-ua-${DST}-apple-darwin_ios.a pjsip/lib-${DST}/libpjsip-ua-${DST}-apple-darwin_ios.a
    cp pjsip/lib/libpjsua-${DST}-apple-darwin_ios.a pjsip/lib-${DST}/libpjsua-${DST}-apple-darwin_ios.a
    cp pjsip/lib/libpjsua2-${DST}-apple-darwin_ios.a pjsip/lib-${DST}/libpjsua2-${DST}-apple-darwin_ios.a

    if [ -d third_party/lib-${DST}/ ]; then
        rm -rf third_party/lib-${DST}/
    fi
    if [ ! -d third_party/lib-${DST}/ ]; then
        mkdir third_party/lib-${DST}/
    fi
    cp third_party/lib/libg7221codec-${DST}-apple-darwin_ios.a third_party/lib-${DST}/libg7221codec-${DST}-apple-darwin_ios.a
    cp third_party/lib/libgsmcodec-${DST}-apple-darwin_ios.a third_party/lib-${DST}/libgsmcodec-${DST}-apple-darwin_ios.a
    cp third_party/lib/libilbccodec-${DST}-apple-darwin_ios.a third_party/lib-${DST}/libilbccodec-${DST}-apple-darwin_ios.a
    cp third_party/lib/libresample-${DST}-apple-darwin_ios.a third_party/lib-${DST}/libresample-${DST}-apple-darwin_ios.a
    cp third_party/lib/libspeex-${DST}-apple-darwin_ios.a third_party/lib-${DST}/libspeex-${DST}-apple-darwin_ios.a
    cp third_party/lib/libsrtp-${DST}-apple-darwin_ios.a third_party/lib-${DST}/libsrtp-${DST}-apple-darwin_ios.a
    cp third_party/lib/libyuv-${DST}-apple-darwin_ios.a third_party/lib-${DST}/libyuv-${DST}-apple-darwin_ios.a
    cp third_party/lib/libwebrtc-${DST}-apple-darwin_ios.a third_party/lib-${DST}/libwebrtc-${DST}-apple-darwin_ios.a
}


if [ ! -f ${OPENSSL_SH} ]; then
    echo "Downloading openssl..."
    curl --create-dirs -o ${OPENSSL_DIR}/scripts/$(basename "$LOOP_TARGETS_URL") ${LOOP_TARGETS_URL}
    curl --create-dirs -o ${OPENSSL_DIR}/scripts/$(basename "$LOOP_ARCHS_URL") ${LOOP_ARCHS_URL}
    curl -# --create-dirs -o ${OPENSSL_SH} ${OPENSSL_URL}
fi

if [ ! -f "${OPENSSL_DIR}/lib/libssl.a" ]; then
    pushd . > /dev/null
    cd ${OPENSSL_DIR}
    /bin/sh ${OPENSSL_SH} --archs="x86_64 i386 arm64 armv7s armv7" # lock targets      # --version="1.0.2k"
    mkdir "${OPENSSL_DIR}/include/openssl"
    mv ${OPENSSL_DIR}/include/*.h ${OPENSSL_DIR}/include/openssl
    popd > /dev/null
fi

if [ ! -f ${PJSIP_ARCHIVE} ]; then
  echo "Downloading pjsip..."
  curl -# -o ${PJSIP_ARCHIVE} ${PJSIP_URL}
fi

PJSIP_NAME=`tar tzf ${PJSIP_ARCHIVE} | sed -e 's@/.*@@' | uniq`
PJSIP_NAME="pjproject-2.7.1"
PJSIP_DIR=${BUILD_DIR}/${PJSIP_NAME}
echo "Using ${PJSIP_NAME}..."

if [ -d ${PJSIP_DIR} ]; then
    echo "Cleaning up..."
#rm -rf ${PJSIP_DIR}
fi

echo "Unarchiving..."
pushd . > /dev/null
cd ${BUILD_DIR}
#tar -xf ${PJSIP_ARCHIVE}
popd > /dev/null

echo "Creating config.h..."
mkdir -p "${PJSIP_DIR}/pjlib/include/pj/"
cp config_site.h ${PJSIP_DIR}/pjlib/include/pj/config_site.h

export CFLAGS="-I${OPENSSL_DIR}/include ${OPTIMIZE_FLAG} ${DEBUG_FLAG}"
export LDFLAGS="-L${OPENSSL_DIR}/lib ${OPTIMIZE_FLAG} ${DEBUG_FLAG}"



echo ${OPENSSL_DIR}

#configure="./configure-iphone --with-ssl=${OPENSSL_DIR} --disable-webrtc --disable-ffmpeg"
configure="./configure-macos --with-ssl=${OPENSSL_DIR}"


echo "cd ${PJSIP_DIR}"
cd ${PJSIP_DIR}

function _build() {
  ARCH=$1
  LOG=${BUILD_DIR}/${ARCH}.log

  echo "Building for ${ARCH}..."

  make distclean > ${LOG} 2>&1
  # ARCH="-arch ${ARCH}" ./configure-iphone --with-ssl=${OPENSSL_DIR} --disable-webrtc --disable-ffmpeg >> ${LOG} 2>&1
  ARCH="-arch ${ARCH}" ./configure-macos --with-ssl=${OPENSSL_DIR} >> ${LOG} 2>&1
  make dep >> ${LOG} 2>&1
  make clean >> ${LOG}
  make >> ${LOG} 2>&1

  copy_libs ${ARCH}
}

function macos() {
  export DEVPATH="`xcrun -sdk macosx --show-sdk-platform-path`/Developer"
  _build "x86_64";
}
function armv7() { _build "armv7"; }
function armv7s() { _build "armv7s"; }
function arm64() { _build "arm64"; }
function i386() {
  export DEVPATH="`xcrun -sdk iphonesimulator --show-sdk-platform-path`/Developer"
  export CFLAGS="-I${OPENSSL_DIR}/include ${OPTIMIZE_FLAG} ${DEBUG_FLAG} -m32 -mios-simulator-version-min=8.0"
  export LDFLAGS="-L${OPENSSL_DIR}/lib ${OPTIMIZE_FLAG} ${DEBUG_FLAG} -m32 -mios-simulator-version-min=8.0"
  _build "i386"
}
function x86_64() {
  export DEVPATH="`xcrun -sdk iphonesimulator --show-sdk-platform-path`/Developer"
  export CFLAGS="-I${OPENSSL_DIR}/include ${OPTIMIZE_FLAG} ${DEBUG_FLAG} -m32 -mios-simulator-version-min=8.0"
  export LDFLAGS="-L${OPENSSL_DIR}/lib ${OPTIMIZE_FLAG} ${DEBUG_FLAG} -m32 -mios-simulator-version-min=8.0"
  _build "x86_64"
}
#test
#armv7 && armv7s && arm64
x86_64

#test
#echo "Making universal lib..."
make distclean > /dev/null
#test
#lipo_libs

cp -R ${OPENH264_DIR}/arm64/include/wels/* ../../Pod/$FOLDER_PJSIP/openh264/wels
cp -R pjlib/include/* ../../Pod/$FOLDER_PJSIP/
cp -R pjlib-util/include/* ../../Pod/$FOLDER_PJSIP/
cp -R pjmedia/include/* ../../Pod/$FOLDER_PJSIP/
cp -R pjnath/include/* ../../Pod/$FOLDER_PJSIP/
cp -R pjsip/include/* ../../Pod/$FOLDER_PJSIP/

cp lib/* ../../Pod/pjsip-lib/


echo "Done"
