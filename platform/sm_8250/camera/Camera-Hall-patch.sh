# ==============================================================================
# Samsung Camera HAL Fix – Polarr, Arcsoft & NightMode Support
# Corrected paths to match source-driven conventions.
# ==============================================================================

LOG_BEGIN "Fixing Camera HAL..."

# --------------------------------------------------------------------------
# Remove outdated camera libraries that can conflict with newer stock libs.
# --------------------------------------------------------------------------
LOG_INFO "Removing outdated system camera libraries..."
SILENT REMOVE "system" "lib64/libsuperresolution_raw.arcsoft.so"
SILENT REMOVE "system" "lib64/libsuperresolutionraw_wrapper_v2.camera.samsung.so"
SILENT REMOVE "system" "lib64/libSemanticMap_v1.camera.samsung.so"
SILENT REMOVE "system" "lib64/libSlowShutter-core.so"
SILENT REMOVE "system" "lib64/libaifrc.aidl.quram.so"
SILENT REMOVE "system" "lib64/libaifrcInterface.camera.samsung.so"
SILENT REMOVE "system" "lib64/libmcaimegpu.samsung.so"
SILENT REMOVE "system" "lib64/libfrtracking_engine.arcsoft.so"
SILENT REMOVE "system" "lib64/libhybrid_high_dynamic_range.arcsoft.so"
SILENT REMOVE "system" "lib64/libstartrail.camera.samsung.so"

# --------------------------------------------------------------------------
# Inject Polarr libraries from the a73 donor firmware.
# --------------------------------------------------------------------------
LOG_BEGIN "Injecting Polarr libraries from a73 donor..."

ADD_FROM_FW "a73" "system" "etc/public.libraries-polarr.txt"
ADD_CONTEXT "system" "etc/public.libraries-polarr.txt" "system_file"

ADD_FROM_FW "a73" "system" "lib64/libBestComposition.polarr.so"
ADD_CONTEXT "system" "lib64/libBestComposition.polarr.so" "system_file"

ADD_FROM_FW "a73" "system" "lib64/libFeature.polarr.so"
ADD_CONTEXT "system" "lib64/libFeature.polarr.so" "system_file"

ADD_FROM_FW "a73" "system" "lib64/libPolarrSnap.polarr.so"
ADD_CONTEXT "system" "lib64/libPolarrSnap.polarr.so" "system_file"

ADD_FROM_FW "a73" "system" "lib64/libTracking.polarr.so"
ADD_CONTEXT "system" "lib64/libTracking.polarr.so" "system_file"

ADD_FROM_FW "a73" "system" "lib64/libYuv.polarr.so"
ADD_CONTEXT "system" "lib64/libYuv.polarr.so" "system_file"

LOG_END "Polarr libraries injection complete"

# --------------------------------------------------------------------------
# Inject the stable camera support libs from stock firmware.
# --------------------------------------------------------------------------
LOG_BEGIN "Injecting requested camera libraries from stock firmware..."

ADD_FROM_FW "r9q" "system" "lib64/libSceneDetector_v1.camera.samsung.so"
ADD_CONTEXT "system" "lib64/libSceneDetector_v1.camera.samsung.so" "system_file"

ADD_FROM_FW "stock" "system" "lib64/libSwIsp_core.camera.samsung.so"
ADD_CONTEXT "system" "lib64/libSwIsp_core.camera.samsung.so" "system_file"

ADD_FROM_FW "stock" "system" "lib64/libhigh_dynamic_range.arcsoft.so"
ADD_CONTEXT "system" "lib64/libhigh_dynamic_range.arcsoft.so" "system_file"

ADD_FROM_FW "stock" "system" "lib64/libhigh_res.arcsoft.so"
ADD_CONTEXT "system" "lib64/libhigh_res.arcsoft.so" "system_file"

ADD_FROM_FW "stock" "system" "lib64/libhumantracking.arcsoft.so"
ADD_CONTEXT "system" "lib64/libhumantracking.arcsoft.so" "system_file"

ADD_FROM_FW "stock" "system" "lib64/libhumantracking_util.camera.samsung.so"
ADD_CONTEXT "system" "lib64/libhumantracking_util.camera.samsung.so" "system_file"

ADD_FROM_FW "stock" "system" "lib64/liblow_light_hdr.arcsoft.so"
ADD_CONTEXT "system" "lib64/liblow_light_hdr.arcsoft.so" "system_file"

ADD_FROM_FW "a73" "system" "lib64/libsecimaging_pdk.camera.samsung.so"
if [[ -f "$WORKSPACE/system/lib64/libsecimaging_pdk.camera.samsung.so" ]]; then
    HEX_EDIT "system/lib64/libsecimaging_pdk.camera.samsung.so" \
    "000000006400000046000000000000000b00000001000000070000000000000000000000" "000000006400000046000000000000000b00000001000000050000000000000000000000"
fi
ADD_CONTEXT "system" "lib64/libsecimaging_pdk.camera.samsung.so" "system_file"

ADD_FROM_FW "stock" "system" "lib64/libsuperresolution.arcsoft.so"
ADD_CONTEXT "system" "lib64/libsuperresolution.arcsoft.so" "system_file"

ADD_FROM_FW "stock" "system" "lib64/libsuperresolution_wrapper_v2.camera.samsung.so"
ADD_CONTEXT "system" "lib64/libsuperresolution_wrapper_v2.camera.samsung.so" "system_file"

ADD_FROM_FW "stock" "system" "lib64/libveengine.arcsoft.so"
ADD_CONTEXT "system" "lib64/libveengine.arcsoft.so" "system_file"

LOG_END "Camera libraries injection complete"

# --------------------------------------------------------------------------
# Inject HDR / SR libs from the p3q donor firmware.
# --------------------------------------------------------------------------
LOG_INFO "Injecting HDR and Super Resolution libs from p3q firmware..."

for blob in \
    lib64/libhigh_dynamic_range.arcsoft.so \
    lib64/liblow_light_hdr.arcsoft.so \
    lib64/libhigh_res.arcsoft.so \
    lib64/libsnap_aidl.snap.samsung.so \
    lib64/libsuperresolution.arcsoft.so \
    lib64/libsuperresolution_raw.arcsoft.so \
    lib64/libsuperresolution_wrapper_v2.camera.samsung.so \
    lib64/libsuperresolutionraw_wrapper_v2.camera.samsung.so \
    lib64/libMultiFrameProcessing30.camera.samsung.so \
    lib64/libMultiFrameProcessing30.snapwrapper.camera.samsung.so \
    lib64/libMultiFrameProcessing30Tuning.camera.samsung.so
 do
    ADD_FROM_FW "p3q" "system" "$blob"
    ADD_CONTEXT "system" "$blob" "system_file"
done

LOG_INFO "HDR and Super Resolution libs injected successfully"

# --------------------------------------------------------------------------
# Inject dm3q NightMode support libs.
# --------------------------------------------------------------------------
LOG_BEGIN "Adding dm3q NightMode libs"
ADD_FROM_FW "dm3q" "system" "lib64/libSwIsp_core.camera.samsung.so"
ADD_CONTEXT "system" "lib64/libSwIsp_core.camera.samsung.so" "system_file"

ADD_FROM_FW "dm3q" "system" "lib64/libSwIsp_wrapper_v1.camera.samsung.so"
ADD_CONTEXT "system" "lib64/libSwIsp_wrapper_v1.camera.samsung.so" "system_file"
LOG_END "Added Night Mode Lib's "

# --------------------------------------------------------------------------
# Inject supporting vendor libraries.
# --------------------------------------------------------------------------
LOG_BEGIN "Injecting supporting libraries..."

ADD_FROM_FW "a73" "vendor" "lib64/libsnaplite_native.so"
ADD_CONTEXT "vendor" "lib64/libsnaplite_native.so" "same_process_hal_file"

ADD_FROM_FW "main" "vendor" "lib/rfsa/adsp/libcamera_nn_skel.so"
ADD_CONTEXT "vendor" "lib/rfsa/adsp/libcamera_nn_skel.so" "vendor_file"

LOG_END "Supporting libraries injection complete"

# HDR10+ (r9q firmware)
LOG_INFO "Injecting HDR10+ support libs from r9q firmware..."
ADD_FROM_FW "r9q" "system" "lib/libstagefright.so"
ADD_FROM_FW "r9q" "vendor" "lib64/X12QS_libTsAe.so"

ADD_CONTEXT "system" "lib/libstagefright.so" "system_file"
ADD_CONTEXT "vendor" "lib64/X12QS_libTsAe.so" "vendor_file"

LOG_INFO "HDR10+ support libs injected successfully"

LOG_END "Camera Processing & HDR10+ patch applied successfully"

# --------------------------------------------------------------------------
# Patch Snap suggestion binary for the stock behavior expected by this device.
# --------------------------------------------------------------------------
if [[ -f "$WORKSPACE/vendor/lib/libshotsuggestion_engines.so" ]]; then
    HEX_EDIT "vendor/lib/libshotsuggestion_engines.so" \
    "0ddb" "0de0"
fi

if [[ -f "$WORKSPACE/vendor/lib64/libshotsuggestion_engines.so" ]]; then
    HEX_EDIT "vendor/lib64/libshotsuggestion_engines.so" \
    "eb010054" "0f000014"
fi

LOG_END "Camera patch applied successfully"

LOG_BEGIN "Fixing Single Take Video Mode..."

# Replace Single Take configs
REMOVE "vendor" "etc/singletake"
ADD_FROM_FW "dm3q" "vendor" "etc/singletake"
LOG_INFO "Replaced Single Take configs from dm3q firmware"

# Enable AI expansion features
FF "GALLERY_CONFIG_AI_EXPANSION" "AI_Timelapse"
LOG_INFO "Enabled AI Timelapse expansion in gallery config"

# Replace SwISP 1.0 configs
REMOVE "vendor" "saiv/swisp_1.0"
ADD_FROM_FW "dm3q" "vendor" "saiv/swisp_1.0"
LOG_INFO "Replaced SwISP 1.0 configs from dm3q firmware"

LOG_END "Single Take Video Mode fix applied successfully"
