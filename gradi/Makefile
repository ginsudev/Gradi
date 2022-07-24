ARCHS = arm64 arm64e
TARGET := iphone:clang:15.5:14.4

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = gradi

gradi_LIBRARIES = gscommon
gradi_FILES = $(shell find Sources/gradi -name '*.swift') $(shell find Sources/gradiC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
gradi_INSTALL_PATH = /Library/PreferenceBundles
gradi_SWIFTFLAGS = -ISources/gradiC/include
gradi_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
