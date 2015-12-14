ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = Bluetoothsnameinsettings

Bluetoothsnameinsettings_FILES = Tweak.xm

Bluetoothsnameinsettings_FRAMEWORKS = UIKit Foundation CoreBluetooth 
Bluetoothsnameinsettings_LDFLAGS += -Wl,-segalign,4000
Bluetoothsnameinsettings_PRIVATE_FRAMEWORKS = BluetoothManager Preferences

include $(THEOS_MAKE_PATH)/tweak.mk


