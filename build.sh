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

#github fork and commit - for concrete scripts version
LOOP_ARCHS_URL="https://raw.githubusercontent.com/marcelosalloum/OpenSSL-for-iPhone/3281c22e0e98571e5f4c0731d203edbae972d43f/scripts/build-loop-archs.sh"
LOOP_TARGETS_URL="https://raw.githubusercontent.com/marcelosalloum/OpenSSL-for-iPhone/3281c22e0e98571e5f4c0731d203edbae972d43f//scripts/build-loop-targets.sh"

OPENSSL_URL="https://raw.githubusercontent.com/marcelosalloum/OpenSSL-for-iPhone/3281c22e0e98571e5f4c0731d203edbae972d43f//build-libssl.sh"

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
    cp pjlib/lib/libpj-${DST}-apple-darwin.a pjlib/lib-${DST}/libpj-${DST}-apple-darwin.a

    if [ -d pjlib-util/lib-${DST}/ ]; then
        rm -rf pjlib-util/lib-${DST}/
    fi
    if [ ! -d pjlib-util/lib-${DST}/ ]; then
        mkdir pjlib-util/lib-${DST}/
    fi
    cp pjlib-util/lib/libpjlib-util-${DST}-apple-darwin.a pjlib-util/lib-${DST}/libpjlib-util-${DST}-apple-darwin.a

    if [ -d pjmedia/lib-${DST}/ ]; then
        rm -rf pjmedia/lib-${DST}/
    fi
    if [ ! -d pjmedia/lib-${DST}/ ]; then
        mkdir pjmedia/lib-${DST}/
    fi
    cp pjmedia/lib/libpjmedia-${DST}-apple-darwin.a pjmedia/lib-${DST}/libpjmedia-${DST}-apple-darwin.a
    cp pjmedia/lib/libpjmedia-audiodev-${DST}-apple-darwin.a pjmedia/lib-${DST}/libpjmedia-audiodev-${DST}-apple-darwin.a
    cp pjmedia/lib/libpjmedia-codec-${DST}-apple-darwin.a pjmedia/lib-${DST}/libpjmedia-codec-${DST}-apple-darwin.a
    cp pjmedia/lib/libpjmedia-videodev-${DST}-apple-darwin.a pjmedia/lib-${DST}/libpjmedia-videodev-${DST}-apple-darwin.a
    cp pjmedia/lib/libpjsdp-${DST}-apple-darwin.a pjmedia/lib-${DST}/libpjsdp-${DST}-apple-darwin.a

    if [ -d pjnath/lib-${DST}/ ]; then
        rm -rf pjnath/lib-${DST}/
    fi
    if [ ! -d pjnath/lib-${DST}/ ]; then
        mkdir pjnath/lib-${DST}/
    fi
    cp pjnath/lib/libpjnath-${DST}-apple-darwin.a pjnath/lib-${DST}/libpjnath-${DST}-apple-darwin.a

    if [ -d pjsip/lib-${DST}/ ]; then
        rm -rf pjsip/lib-${DST}/
    fi
    if [ ! -d pjsip/lib-${DST}/ ]; then
        mkdir pjsip/lib-${DST}/
    fi
    cp pjsip/lib/libpjsip-${DST}-apple-darwin.a pjsip/lib-${DST}/libpjsip-${DST}-apple-darwin.a
    cp pjsip/lib/libpjsip-simple-${DST}-apple-darwin.a pjsip/lib-${DST}/libpjsip-simple-${DST}-apple-darwin.a
    cp pjsip/lib/libpjsip-ua-${DST}-apple-darwin.a pjsip/lib-${DST}/libpjsip-ua-${DST}-apple-darwin.a
    cp pjsip/lib/libpjsua-${DST}-apple-darwin.a pjsip/lib-${DST}/libpjsua-${DST}-apple-darwin.a
    cp pjsip/lib/libpjsua2-${DST}-apple-darwin.a pjsip/lib-${DST}/libpjsua2-${DST}-apple-darwin.a

    if [ -d third_party/lib-${DST}/ ]; then
        rm -rf third_party/lib-${DST}/
    fi
    if [ ! -d third_party/lib-${DST}/ ]; then
        mkdir third_party/lib-${DST}/
    fi
    cp third_party/lib/libg7221codec-${DST}-apple-darwin.a third_party/lib-${DST}/libg7221codec-${DST}-apple-darwin.a
    cp third_party/lib/libgsmcodec-${DST}-apple-darwin.a third_party/lib-${DST}/libgsmcodec-${DST}-apple-darwin.a
    cp third_party/lib/libilbccodec-${DST}-apple-darwin.a third_party/lib-${DST}/libilbccodec-${DST}-apple-darwin.a
    cp third_party/lib/libresample-${DST}-apple-darwin.a third_party/lib-${DST}/libresample-${DST}-apple-darwin.a
    cp third_party/lib/libspeex-${DST}-apple-darwin.a third_party/lib-${DST}/libspeex-${DST}-apple-darwin.a
    cp third_party/lib/libsrtp-${DST}-apple-darwin.a third_party/lib-${DST}/libsrtp-${DST}-apple-darwin.a
    cp third_party/lib/libyuv-${DST}-apple-darwin.a third_party/lib-${DST}/libyuv-${DST}-apple-darwin.a
    cp third_party/lib/libwebrtc-${DST}-apple-darwin.a third_party/lib-${DST}/libwebrtc-${DST}-apple-darwin.a
}

copy_mac_libs () {
  DST=${1}
  cp pjlib/lib-${DST}/libpj-${DST}-apple-darwin.a lib/libpj-${DST}-apple-darwin.a
  cp pjlib-util/lib-${DST}/libpjlib-util-${DST}-apple-darwin.a lib/libpjlib-util-${DST}-apple-darwin.a
  cp pjmedia/lib-${DST}/libpjmedia-${DST}-apple-darwin.a lib/libpjmedia-${DST}-apple-darwin.a
  cp pjmedia/lib-${DST}/libpjmedia-audiodev-${DST}-apple-darwin.a lib/libpjmedia-audiodev-${DST}-apple-darwin.a
  cp pjmedia/lib-${DST}/libpjmedia-codec-${DST}-apple-darwin.a lib/libpjmedia-codec-${DST}-apple-darwin.a
  cp pjmedia/lib-${DST}/libpjmedia-videodev-${DST}-apple-darwin.a lib/libpjmedia-videodev-${DST}-apple-darwin.a
  cp pjmedia/lib-${DST}/libpjsdp-${DST}-apple-darwin.a lib/libpjsdp-${DST}-apple-darwin.a
  cp pjnath/lib-${DST}/libpjnath-${DST}-apple-darwin.a lib/libpjnath-${DST}-apple-darwin.a
  cp pjsip/lib-${DST}/libpjsip-${DST}-apple-darwin.a lib/libpjsip-${DST}-apple-darwin.a
  cp pjsip/lib-${DST}/libpjsip-simple-${DST}-apple-darwin.a lib/libpjsip-simple-${DST}-apple-darwin.a
  cp pjsip/lib-${DST}/libpjsip-ua-${DST}-apple-darwin.a lib/libpjsip-ua-${DST}-apple-darwin.a
  cp pjsip/lib-${DST}/libpjsua-${DST}-apple-darwin.a lib/libpjsua-${DST}-apple-darwin.a
  cp pjsip/lib-${DST}/libpjsua2-${DST}-apple-darwin.a lib/libpjsua2-${DST}-apple-darwin.a
  cp third_party/lib-${DST}/libg7221codec-${DST}-apple-darwin.a lib/libg7221codec-${DST}-apple-darwin.a
  cp third_party/lib-${DST}/libgsmcodec-${DST}-apple-darwin.a lib/libgsmcodec-${DST}-apple-darwin.a
  cp third_party/lib-${DST}/libilbccodec-${DST}-apple-darwin.a lib/libilbccodec-${DST}-apple-darwin.a
  cp third_party/lib-${DST}/libresample-${DST}-apple-darwin.a lib/libresample-${DST}-apple-darwin.a
  cp third_party/lib-${DST}/libspeex-${DST}-apple-darwin.a lib/libspeex-${DST}-apple-darwin.a
  cp third_party/lib-${DST}/libsrtp-${DST}-apple-darwin.a lib/libsrtp-${DST}-apple-darwin.a
  cp third_party/lib-${DST}/libyuv-${DST}-apple-darwin.a lib/libyuv-${DST}-apple-darwin.a
  cp third_party/lib-${DST}/libwebrtc-${DST}-apple-darwin.a lib/libwebrtc-${DST}-apple-darwin.a
}

lipo_libs () {
xcrun -sdk iphoneos lipo -arch armv7  pjlib/lib-armv7/libpj-armv7-apple-darwin_ios.a \
                         -arch armv7s pjlib/lib-armv7s/libpj-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjlib/lib-arm64/libpj-arm64-apple-darwin_ios.a \
                         -create -output lib/libpj-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjlib-util/lib-armv7/libpjlib-util-armv7-apple-darwin_ios.a \
                         -arch armv7s pjlib-util/lib-armv7s/libpjlib-util-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjlib-util/lib-arm64/libpjlib-util-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjlib-util-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjmedia/lib-armv7/libpjmedia-armv7-apple-darwin_ios.a \
                         -arch armv7s pjmedia/lib-armv7s/libpjmedia-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjmedia/lib-arm64/libpjmedia-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjmedia-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjmedia/lib-armv7/libpjmedia-audiodev-armv7-apple-darwin_ios.a \
                         -arch armv7s pjmedia/lib-armv7s/libpjmedia-audiodev-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjmedia/lib-arm64/libpjmedia-audiodev-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjmedia-audiodev-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjmedia/lib-armv7/libpjmedia-codec-armv7-apple-darwin_ios.a \
                         -arch armv7s pjmedia/lib-armv7s/libpjmedia-codec-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjmedia/lib-arm64/libpjmedia-codec-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjmedia-codec-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjmedia/lib-armv7/libpjmedia-videodev-armv7-apple-darwin_ios.a \
                         -arch armv7s pjmedia/lib-armv7s/libpjmedia-videodev-armv7s-apple-darwin_ios.a \
                         -arch arm64 pjmedia/lib-arm64/libpjmedia-videodev-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjmedia-videodev-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjmedia/lib-armv7/libpjsdp-armv7-apple-darwin_ios.a \
                         -arch armv7s pjmedia/lib-armv7s/libpjsdp-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjmedia/lib-arm64/libpjsdp-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjsdp-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjnath/lib-armv7/libpjnath-armv7-apple-darwin_ios.a \
                         -arch armv7s pjnath/lib-armv7s/libpjnath-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjnath/lib-arm64/libpjnath-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjnath-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjsip/lib-armv7/libpjsip-armv7-apple-darwin_ios.a \
                         -arch armv7s pjsip/lib-armv7s/libpjsip-armv7s-apple-darwin_ios.a \
                         -arch arm64 pjsip/lib-arm64/libpjsip-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjsip-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjsip/lib-armv7/libpjsip-simple-armv7-apple-darwin_ios.a \
                         -arch armv7s pjsip/lib-armv7s/libpjsip-simple-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjsip/lib-arm64/libpjsip-simple-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjsip-simple-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjsip/lib-armv7/libpjsip-ua-armv7-apple-darwin_ios.a \
                         -arch armv7s pjsip/lib-armv7s/libpjsip-ua-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjsip/lib-arm64/libpjsip-ua-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjsip-ua-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjsip/lib-armv7/libpjsua-armv7-apple-darwin_ios.a \
                         -arch armv7s pjsip/lib-armv7s/libpjsua-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjsip/lib-arm64/libpjsua-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjsua-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  pjsip/lib-armv7/libpjsua2-armv7-apple-darwin_ios.a \
                         -arch armv7s pjsip/lib-armv7s/libpjsua2-armv7s-apple-darwin_ios.a \
                         -arch arm64  pjsip/lib-arm64/libpjsua2-arm64-apple-darwin_ios.a \
                         -create -output lib/libpjsua2-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  third_party/lib-armv7/libg7221codec-armv7-apple-darwin_ios.a \
                         -arch armv7s third_party/lib-armv7s/libg7221codec-armv7s-apple-darwin_ios.a \
                         -arch arm64  third_party/lib-arm64/libg7221codec-arm64-apple-darwin_ios.a \
                         -create -output lib/libg7221codec-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  third_party/lib-armv7/libgsmcodec-armv7-apple-darwin_ios.a \
                         -arch armv7s third_party/lib-armv7s/libgsmcodec-armv7s-apple-darwin_ios.a \
                         -arch arm64  third_party/lib-arm64/libgsmcodec-arm64-apple-darwin_ios.a \
                         -create -output lib/libgsmcodec-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  third_party/lib-armv7/libilbccodec-armv7-apple-darwin_ios.a \
                         -arch armv7s third_party/lib-armv7s/libilbccodec-armv7s-apple-darwin_ios.a \
                         -arch arm64  third_party/lib-arm64/libilbccodec-arm64-apple-darwin_ios.a \
                         -create -output lib/libilbccodec-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  third_party/lib-armv7/libresample-armv7-apple-darwin_ios.a \
                         -arch armv7s third_party/lib-armv7s/libresample-armv7s-apple-darwin_ios.a \
                         -arch arm64  third_party/lib-arm64/libresample-arm64-apple-darwin_ios.a \
                         -create -output lib/libresample-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  third_party/lib-armv7/libspeex-armv7-apple-darwin_ios.a \
                         -arch armv7s third_party/lib-armv7s/libspeex-armv7s-apple-darwin_ios.a \
                         -arch arm64 third_party/lib-arm64/libspeex-arm64-apple-darwin_ios.a \
                         -create -output lib/libspeex-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  third_party/lib-armv7/libsrtp-armv7-apple-darwin_ios.a \
                         -arch armv7s third_party/lib-armv7s/libsrtp-armv7s-apple-darwin_ios.a \
                         -arch arm64 third_party/lib-arm64/libsrtp-arm64-apple-darwin_ios.a \
                         -create -output lib/libsrtp-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  third_party/lib-armv7/libyuv-armv7-apple-darwin_ios.a \
                         -arch armv7s third_party/lib-armv7s/libyuv-armv7s-apple-darwin_ios.a \
                         -arch arm64 third_party/lib-arm64/libyuv-arm64-apple-darwin_ios.a \
                         -create -output lib/libyuv-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  third_party/lib-armv7/libwebrtc-armv7-apple-darwin_ios.a \
                         -arch armv7s third_party/lib-armv7s/libwebrtc-armv7s-apple-darwin_ios.a \
                         -arch arm64 third_party/lib-arm64/libwebrtc-arm64-apple-darwin_ios.a \
                         -create -output lib/libwebrtc-arm-apple-darwin_ios.a

xcrun -sdk iphoneos lipo -arch armv7  ${OPENH264_DIR}/armv7/lib/libopenh264.a \
                         -arch armv7s ${OPENH264_DIR}/armv7s/lib/libopenh264.a \
                         -arch arm64 ${OPENH264_DIR}/arm64/lib/libopenh264.a \
                         -create -output lib/libopenh264.a
}

if [ ! -f ${OPENSSL_SH} ]; then
    echo "Downloading openssl..."
    curl --create-dirs -o ${OPENSSL_DIR}/scripts/$(basename "$LOOP_TARGETS_URL") ${LOOP_TARGETS_URL}
    curl --create-dirs -o ${OPENSSL_DIR}/scripts/$(basename "$LOOP_ARCHS_URL") ${LOOP_ARCHS_URL}
    curl --create-dirs -o ${OPENSSL_SH} ${OPENSSL_URL}
fi

if [ ! -f "${OPENSSL_DIR}/lib/libssl.a" ]; then
    pushd . > /dev/null
    cd ${OPENSSL_DIR}
    /bin/sh ${OPENSSL_SH} --archs="MacOSX_x86_64" # lock targets      # --version="1.0.2k"
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
echo "cd BUILD_DIR: ${BUILD_DIR}"
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



cd ${PJSIP_DIR}
echo "cd PJSIP_DIR: ${PJSIP_DIR}"

function _build() {
  ARCH=$1
  LOG=${BUILD_DIR}/${ARCH}.log

  echo "Building for ${ARCH}..."
  pwd

  make distclean > ${LOG} 2>&1
  # ARCH="-arch ${ARCH}" ./configure-iphone --with-ssl=${OPENSSL_DIR} --disable-webrtc --disable-ffmpeg >> ${LOG} 2>&1
  ARCH="-arch ${ARCH}" ./configure-macos --with-ssl=${OPENSSL_DIR} >> ${LOG} 2>&1
  make dep >> ${LOG} 2>&1
  make clean >> ${LOG}
  make >> ${LOG} 2>&1

  copy_libs ${ARCH}
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

function macos_64() {
  export DEVPATH="`xcrun -sdk macosx --show-sdk-platform-path`/Developer"
  #_build "x86_64 --target=x86_64-apple-ios13.0-macabi"
  _build "x86_64"
}

macos_64

#make distclean > /dev/null

copy_mac_libs "x86_64"

#cp -R ${OPENH264_DIR}/arm64/include/wels/* ../../Pod/$FOLDER_PJSIP/openh264/wels
cp -R pjlib/include/* ../../Pod/$FOLDER_PJSIP/
cp -R pjlib-util/include/* ../../Pod/$FOLDER_PJSIP/
cp -R pjmedia/include/* ../../Pod/$FOLDER_PJSIP/
cp -R pjnath/include/* ../../Pod/$FOLDER_PJSIP/
cp -R pjsip/include/* ../../Pod/$FOLDER_PJSIP/


cp lib/* ../../Pod/pjsip-lib/
cp ../openssl/lib/* ../../Pod/pjsip-lib/


echo "Done"
