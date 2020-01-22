#!/bin/bash

# This script builds the iOS and Mac openSSL libraries
# Download openssl http://www.openssl.org/source/ and place the tarball next to this script

# Credits:
# https://github.com/st3fan/ios-openssl
# https://github.com/x2on/OpenSSL-for-iPhone/blob/master/build-libssl.sh


set -e

usage ()
{
	echo "usage: $0 [minimum iOS SDK version (default 8.2)]"
	exit 127
}

if [ $1 -e "-h" ]; then
	usage
fi

if [ -z $1 ]; then
	SDK_VERSION="10.15"
else
	SDK_VERSION=$1
fi

OPENSSL_VERSION="openssl-1.0.1m"
DEVELOPER=`xcode-select -print-path`

TMP_DIR="$(pwd)/../tmp"

buildMac()
{
	ARCH=$1
	TARGET="darwin64-x86_64-cc"

	echo "Building ${OPENSSL_VERSION} for ${ARCH}"
	echo "Target: ${TARGET}"

	pushd . > /dev/null
	cd "${OPENSSL_VERSION}"
	./Configure ${TARGET} --openssldir="${TMP_DIR}/${OPENSSL_VERSION}-${ARCH}" &> "../${OPENSSL_VERSION}-${ARCH}.log"
	echo "buildMac->Configure completed for ${ARCH}"
	make >> "../${OPENSSL_VERSION}-${ARCH}.log" 2>&1
	echo "buildMac->make completed for ${ARCH}"
	make install_sw >> "../${OPENSSL_VERSION}-${ARCH}.log" 2>&1
	echo "buildMac->make install completed for ${ARCH}"
	make clean >> "../${OPENSSL_VERSION}-${ARCH}.log" 2>&1
	echo "buildMac->make clean completed for ${ARCH}"
	popd > /dev/null
}

buildIOS()
{
	ARCH=$1

	pushd . > /dev/null
	cd "${OPENSSL_VERSION}"

	if [[ "${ARCH}" == "i386" || "${ARCH}" == "x86_64" ]]; then
		PLATFORM="iPhoneSimulator"
	else
		if [[ "${ARCH}" == "macos64" ]]; then
			ARCH="x86_64"
			PLATFORM="MacOSX"
		fi

		PLATFORM="iPhoneOS"
		sed -ie "s!static volatile sig_atomic_t intr_signal;!static volatile intr_signal;!" "crypto/ui/ui_openssl.c"
	fi

	export $PLATFORM
	export CROSS_TOP="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
	export CROSS_SDK="${PLATFORM}${SDK_VERSION}.sdk"
	export BUILD_TOOLS="${DEVELOPER}"
	export CC="${BUILD_TOOLS}/usr/bin/gcc -arch ${ARCH}"

	echo "Building ${OPENSSL_VERSION} for ${PLATFORM} ${SDK_VERSION} ${ARCH}"

	if [[ "${ARCH}" == "x86_64" && "${PLATFORM}" == "iPhoneSimulator" ]]; then
		./Configure darwin64-x86_64-cc --openssldir="${TMP_DIR}/${OPENSSL_VERSION}-iOS-${ARCH}" &> "${TMP_DIR}/${OPENSSL_VERSION}-iOS-${ARCH}.log"
	else
		./Configure iphoneos-cross --openssldir="${TMP_DIR}/${OPENSSL_VERSION}-iOS-${ARCH}" &> "${TMP_DIR}/${OPENSSL_VERSION}-iOS-${ARCH}.log"
	fi
	# add -isysroot to CC=
	sed -ie "s!^CFLAG=!CFLAG=-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} -miphoneos-version-min=${SDK_VERSION} !" "Makefile"

	make >> "${TMP_DIR}/${OPENSSL_VERSION}-iOS-${ARCH}.log" 2>&1
	make install_sw >> "${TMP_DIR}/${OPENSSL_VERSION}-iOS-${ARCH}.log" 2>&1
	make clean >> "${TMP_DIR}/${OPENSSL_VERSION}-iOS-${ARCH}.log" 2>&1
	popd > /dev/null
}

echo "Cleaning up"
rm -rf include/openssl/* lib/*

mkdir -p lib
mkdir -p include/openssl/

rm -rf "${TMP_DIR}/${OPENSSL_VERSION}-*"
rm -rf "${TMP_DIR}/${OPENSSL_VERSION}-*.log"

rm -rf "${OPENSSL_VERSION}"

if [ ! -e ${OPENSSL_VERSION}.tar.gz ]; then
	echo "Downloading ${OPENSSL_VERSION}.tar.gz"
	curl -O https://www.openssl.org/source/${OPENSSL_VERSION}.tar.gz
else
	echo "Using ${OPENSSL_VERSION}.tar.gz"
fi

echo "Unpacking openssl"
tar xfz "${OPENSSL_VERSION}.tar.gz"
chmod -R o+rwx "${OPENSSL_VERSION}"

buildMac "x86_64"
#buildIOS "macos64"

echo "Copying headers"
cp ${TMP_DIR}/${OPENSSL_VERSION}-x86_64/include/openssl/* include/openssl/

echo "Building Mac libraries"
cp "${TMP_DIR}/${OPENSSL_VERSION}-x86_64/lib/libcrypto.a" lib/libcrypto.a
cp "${TMP_DIR}/${OPENSSL_VERSION}-x86_64/lib/libssl.a" lib/libssl.a

echo "Cleaning up"
rm -rf ${TMP_DIR}/${OPENSSL_VERSION}-*
rm -rf ${OPENSSL_VERSION}

echo "Done"
