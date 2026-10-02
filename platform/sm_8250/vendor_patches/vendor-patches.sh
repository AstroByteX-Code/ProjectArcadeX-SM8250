# ==============================================================================
# Patch: Vendor compatibility patch (AstroROM style)
# Context:
#   - Removes legacy vibrator and configstore HAL entries
#   - Patches the VINTF manifest to match the donor firmware layout
#   - Injects stable donor blobs matching the repo source pattern
# ==============================================================================

LOG_BEGIN "Patching vendor compatibility layer..."

# --------------------------------------------------------------------------
# Remove legacy vibrator HIDL services
# --------------------------------------------------------------------------
LOG_BEGIN "Removing legacy vibrator HIDL services..."
SILENT REMOVE "vendor" "bin/hw/vendor.samsung.hardware.vibrator@2.2-service"
SILENT REMOVE "vendor" "etc/init/vendor.samsung.hardware.vibrator@2.2-service.rc"
SILENT REMOVE "vendor" "lib64/vendor.samsung.hardware.vibrator@2.0.so"
SILENT REMOVE "vendor" "lib64/vendor.samsung.hardware.vibrator@2.1.so"
SILENT REMOVE "vendor" "lib64/vendor.samsung.hardware.vibrator@2.2.so"
LOG_END "Legacy vibrator services removed"

# --------------------------------------------------------------------------
# Patch vendor manifest to drop old HAL entries
# --------------------------------------------------------------------------
LOG_BEGIN "Patching /vendor/etc/vintf/manifest.xml"

# Remove android.hardware.vibrator HAL entry
sed -i '/<hal format="hidl">.*/{:a;N;/<\/hal>/!ba;/android.hardware.vibrator/d}' \
    "$WORKSPACE/vendor/etc/vintf/manifest.xml"
LOG_INFO "Removed android.hardware.vibrator HIDL entry"

# Remove vendor.samsung.hardware.vibrator HAL entry
sed -i '/<hal format="hidl">.*/{:a;N;/<\/hal>/!ba;/vendor.samsung.hardware.vibrator/d}' \
    "$WORKSPACE/vendor/etc/vintf/manifest.xml"
LOG_INFO "Removed vendor.samsung.hardware.vibrator HIDL entry"

LOG_END "Manifest patch complete"

# --------------------------------------------------------------------------
# Inject AIDL vibrator HAL from a52 donor
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

# --------------------------------------------------------------------------
# Target-specific donor blobs
# --------------------------------------------------------------------------
    LOG_BEGIN "Injecting dm3q light blobs..."
    ADD_FROM_FW "dm3q" "vendor" "bin/hw/vendor.samsung.hardware.light-service"
    ADD_CONTEXT "vendor" "bin/hw/vendor.samsung.hardware.light-service" "hal_light_default_exec"
    ADD_FROM_FW "dm3q" "vendor" "lib64/vendor.samsung.hardware.light-V1-ndk_platform.so"
    ADD_CONTEXT "vendor" "lib64/vendor.samsung.hardware.light-V1-ndk_platform.so" "vendor_file"
    LOG_END "Light blobs injected"

    LOG_BEGIN "Injecting dm3q Wi‑Fi blobs..."
    ADD_FROM_FW "dm3q" "vendor" "bin/hw/wpa_supplicant"
    ADD_CONTEXT "vendor" "bin/hw/wpa_supplicant" "hal_wifi_supplicant_default_exec"
    LOG_END "Wi‑Fi blobs injected"

# --------------------------------------------------------------------------
# Adaptive HFR vendor props
# --------------------------------------------------------------------------
LOG_BEGIN "Setting Adaptive HFR flags..."
BPROP "vendor" "debug.sf.show_refresh_rate_overlay_render_rate" "true"
BPROP "vendor" "ro.surface_flinger.game_default_frame_rate_override" "60"
BPROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate" "true"
BPROP "vendor" "ro.surface_flinger.set_idle_timer_ms" "250"
BPROP "vendor" "ro.surface_flinger.set_touch_timer_ms" "300"
BPROP "vendor" "ro.surface_flinger.set_display_power_timer_ms" "200"
BPROP "vendor" "ro.surface_flinger.enable_frame_rate_override" "true"
LOG_END "Adaptive HFR flags set"

# --------------------------------------------------------------------------
# Vulkan enablement
# --------------------------------------------------------------------------
LOG_BEGIN "Enabling Vulkan..."
BPROP "vendor" "ro.hwui.use_vulkan" "true"
LOG_END "Vulkan enabled"


LOG_BEGIN "Patching /vendor/etc/vintf/manifest.xml"

# Upgrade manifest target-level
sed -i "s/type=\"device\" target-level=\"4\">/type=\"device\" target-level=\"5\">/" \
    "$WORKSPACE/vendor/etc/vintf/manifest.xml"
LOG_INFO "Upgraded manifest target-level from 4 → 5"

# Remove configstore HAL entry
sed -i '/<hal format="hidl">.*/{:a;N;/<\/hal>/!ba;/android.hardware.configstore/d}' \
    "$WORKSPACE/vendor/etc/vintf/manifest.xml"
LOG_INFO "Removed android.hardware.configstore HAL entry"

# Insert kernel target-level declaration
sed -i "/^<\/manifest>\$/i\\    <kernel target-level=\"5\"/>" \
    "$WORKSPACE/vendor/etc/vintf/manifest.xml"
LOG_INFO "Inserted kernel target-level=5 declaration"

LOG_END "Manifest upgrade patch complete"

# --------------------------------------------------------------------------
# Remove configstore 1.1 service
# --------------------------------------------------------------------------
LOG_BEGIN "Removing configstore-1.1 service..."
REMOVE "vendor" "bin/hw/android.hardware.configstore@1.1-service"
REMOVE "vendor" "etc/init/android.hardware.configstore@1.1-service.rc"
REMOVE "vendor" "etc/seccomp_policy/configstore@1.1.policy"
LOG_END "Configstore service removed"

LOG_END "Vendor compatibility patch applied successfully"
