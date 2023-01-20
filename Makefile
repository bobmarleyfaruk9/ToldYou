INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ToldYou

ToldYou_FILES = Tweak.x
ToldYou_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += toldyoupreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
