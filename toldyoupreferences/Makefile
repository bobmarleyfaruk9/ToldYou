
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ToldYouPreferences

ToldYouPreferences_FILES = HUSRootListController.m
ToldYouPreferences_INSTALL_PATH = /Library/PreferenceBundles
ToldYouPreferences_FRAMEWORKS = UIKit
ToldYouPreferences_PRIVATE_FRAMEWORKS = Preferences
ToldYouPreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ToldYouPreferences.plist$(ECHO_END)
