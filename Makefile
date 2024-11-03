ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeiboNoAds

# 添加头文件搜索路径
WeiboNoAds_CFLAGS = -fobjc-arc -I./WeiboHeaders
WeiboNoAds_FILES = Tweak.x
WeiboNoAds_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk