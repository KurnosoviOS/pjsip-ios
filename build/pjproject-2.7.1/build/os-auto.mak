# build/os-auto.mak.  Generated from os-auto.mak.in by configure.

export OS_CFLAGS   := $(CC_DEF)PJ_AUTOCONF=1 -I/Users/eastwindkurnosov/Documents/GitHub/pjsip-ios/build/openssl/include -O2  -miphoneos-version-min=13.0 -DPJ_SDK_NAME="\"MacOSX10.15.sdk\"" -arch x86_64 -target x86_64-apple-ios13.0-macabi -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/System/iOSSupport/System/Library/Frameworks -DPJ_IS_BIG_ENDIAN=0 -DPJ_IS_LITTLE_ENDIAN=1 -I/Users/eastwindkurnosov/Documents/GitHub/pjsip-ios/build/openssl/include

export OS_CXXFLAGS := $(CC_DEF)PJ_AUTOCONF=1 -g -O2

export OS_LDFLAGS  := -L/Users/eastwindkurnosov/Documents/GitHub/pjsip-ios/build/openssl/lib -O2  -miphoneos-version-min=13.0 -arch x86_64 -target x86_64-apple-ios13.0-macabi -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/System/iOSSupport/System/Library/Frameworks -framework AudioToolbox -framework Foundation -framework UIKit -L/Users/eastwindkurnosov/Documents/GitHub/pjsip-ios/build/openssl/lib -lssl -lcrypto -lm -lpthread  -framework CoreAudio -framework CoreFoundation -framework AudioToolbox -framework CFNetwork -framework UIKit -framework Foundation -framework AppKit -framework AVFoundation -framework CoreGraphics -framework QuartzCore -framework CoreVideo -framework CoreMedia -framework VideoToolbox

export OS_SOURCES  := 


