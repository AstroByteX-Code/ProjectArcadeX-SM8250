# ==============================================================================
# Patch: Vibrator HAL AIDL Migration
# Context:
#   - Removes legacy vibrator HIDL services
#   - Patches manifest to drop old HAL entries
#   - Injects AIDL vibrator HAL from a52 donor
#   - Adds supporting libs from a73 and source firmware
# ==============================================================================

# --------------------------------------------------------------------------
# Remove outdated vibrator HAL services
# --------------------------------------------------------------------------
LOG_BEGIN "Removing legacy vibrator HIDL services..."

SILENT REMOVE "vendor" "bin/hw/vendor.samsung.hardware.vibrator@2.2-service"
SILENT REMOVE "vendor" "etc/init/vendor.samsung.hardware.vibrator@2.2-service.rc"
SILENT REMOVE "vendor" "lib64/vendor.samsung.hardware.vibrator@2.0.so"
SILENT REMOVE "vendor" "lib64/vendor.samsung.hardware.vibrator@2.1.so"
SILENT REMOVE "vendor" "lib64/vendor.samsung.hardware.vibrator@2.2.so"

LOG_END "Legacy vibrator services removed"

# --------------------------------------------------------------------------
# Patch manifest to remove old vibrator HAL entries
# --------------------------------------------------------------------------
LOG_BEGIN "Patching /vendor/etc/vintf/manifest.xml"

EVAL "sed -i '/<hal format=\"hidl\">.*/{:a;N;/<\/hal>/!ba;/android.hardware.vibrator/d}' \"$WORKSPACE/vendor/etc/vintf/manifest.xml\""
EVAL "sed -i '/<hal format=\"hidl\">.*/{:a;N;/<\/hal>/!ba;/vendor.samsung.hardware.vibrator/d}' \"$WORKSPACE/vendor/etc/vintf/manifest.xml\""

LOG_END "Manifest patch complete"

# --------------------------------------------------------------------------
# Inject AIDL vibrator HAL
# --------------------------------------------------------------------------
LOG_BEGIN "Injecting AIDL vibrator HAL from a52 donor..."

ADD_FROM_FW "a52" "vendor" "bin/hw/vendor.samsung.hardware.vibrator-service"
ADD_CONTEXT "vendor" "bin/hw/vendor.samsung.hardware.vibrator-service" "hal_vibrator_default_exec"

ADD_FROM_FW "a52" "vendor" "etc/init/vendor.samsung.hardware.vibrator-default.rc"
ADD_CONTEXT "vendor" "etc/init/vendor.samsung.hardware.vibrator-default.rc" "vendor_file"

ADD_FROM_FW "a52" "vendor" "etc/vintf/manifest/vendor.samsung.hardware.vibrator-default.xml"
ADD_CONTEXT "vendor" "etc/vintf/manifest/vendor.samsung.hardware.vibrator-default.xml" "vendor_file"

ADD_FROM_FW "a52" "vendor" "lib64/vendor.samsung.hardware.vibrator-V3-ndk_platform.so"
ADD_CONTEXT "vendor" "lib64/vendor.samsung.hardware.vibrator-V3-ndk_platform.so" "vendor_file"

LOG_END "AIDL vibrator HAL injection complete"


