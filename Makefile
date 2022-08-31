ARCHS = arm64 arm64e
THEOS_DEVICE_IP = root@localhost -p 2222
TARGET := iphone:clang:15.5:14.4
INSTALL_TARGET_PROCESSES = SpringBoard
PACKAGE_VERSION = 2.2.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Gradi

Gradi_LIBRARIES = gsutils
Gradi_PRIVATE_FRAMEWORKS = CoverSheet PlatterKit SpringBoard MediaRemote FrontBoard
Gradi_FILES = $(shell find Sources/Gradi -name '*.swift') $(shell find Sources/GradiC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Gradi_SWIFTFLAGS = -ISources/GradiC/include
Gradi_CFLAGS = -fobjc-arc -ISources/GradiC/include

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += gradi
include $(THEOS_MAKE_PATH)/aggregate.mk
