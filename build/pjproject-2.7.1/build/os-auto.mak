# build/os-auto.mak.  Generated from os-auto.mak.in by configure.

export OS_CFLAGS   := $(CC_DEF)PJ_AUTOCONF=1 -I/Users/eastwindkurnosov/Documents/GitHub/pjsip-macos/build/sdl-export/include/SDL2 -mmacosx-version-min=10.15 -DPJ_SDK_NAME="\"MacOSX10.15.sdk\"" -arch x86_64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -DPJ_IS_BIG_ENDIAN=0 -DPJ_IS_LITTLE_ENDIAN=1 -I/Users/eastwindkurnosov/Documents/GitHub/pjsip-macos/build/openssl/include

export OS_CXXFLAGS := $(CC_DEF)PJ_AUTOCONF=1 -g -O2

export OS_LDFLAGS  := -L/Users/eastwindkurnosov/Documents/GitHub/pjsip-macos/build/sdl-export/lib -mmacosx-version-min=10.15 -arch x86_64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -framework AudioToolbox -framework Foundation -L/Users/eastwindkurnosov/Documents/GitHub/pjsip-macos/build/openssl/lib -lssl -lcrypto -lm -lpthread  -framework CoreAudio -framework CoreServices -framework AudioUnit -framework AudioToolbox -framework Foundation -framework AppKit -framework AVFoundation -framework CoreGraphics -framework QuartzCore -framework CoreVideo -framework CoreMedia -framework VideoToolbox -framework OpenGL

export OS_SOURCES  := 


