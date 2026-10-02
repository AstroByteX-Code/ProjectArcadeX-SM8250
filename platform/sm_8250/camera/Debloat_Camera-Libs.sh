# ==============================================================================
# Patch: Camera libs debloat (AstroROM style)
# Context:
#   - Removes unused or mismatched camera libraries
#   - Uses the repo's expected source-driven pattern
#   - Keeps the script valid and consistent with other camera patches
# ==============================================================================

LOG_BEGIN "Debloating unused camera libraries..."

# Initialize SAIV config from stock if not already set
if [[ -z "$STOCK_SAIV_CONFIG_ARDOODLE_LIB" ]]; then
    STOCK_SAIV_CONFIG_ARDOODLE_LIB="$(GET_FF_VAL "stock" "SEC_FLOATING_FEATURE_SAIV_CONFIG_ARDOODLE_LIB")"
    LOG_INFO "Loaded SAIV config from stock firmware"
fi

# Relighting API
if [[ -f "$WORKSPACE/system/system/cameradata/portrait_data/single_bokeh_feature.json" ]] && \
   ! grep -q '"system"' "$WORKSPACE/system/system/cameradata/portrait_data/single_bokeh_feature.json" 2>/dev/null; then
    SILENT REMOVE "system" "lib64/libRelighting_API.camera.samsung.so"
    LOG_INFO "Removed Relighting API lib"
fi

# Pet detection
if [[ -f "$WORKSPACE/system/system/cameradata/singletake/service-feature.xml" ]] && \
   ! grep -q "SUPPORT_PET_DETECTION.*true" "$WORKSPACE/system/system/cameradata/singletake/service-feature.xml" 2>/dev/null && \
   [[ "$STOCK_SAIV_CONFIG_ARDOODLE_LIB" != *"PET_DETECTION"* ]]; then
    SILENT REMOVE "system" "lib64/lib_pet_detection.arcsoft.so"
    LOG_INFO "Removed pet detection lib"
fi

# Best photo
if [[ -f "$WORKSPACE/system/system/cameradata/camera-feature.xml" ]] && \
   ! grep -q "SUPPORT_SINGLE_TAKE_BURST_CAPTURE.*true" "$WORKSPACE/system/system/cameradata/camera-feature.xml" 2>/dev/null; then
    SILENT REMOVE "system" "lib64/libBestPhoto.camera.samsung.so"
    LOG_INFO "Removed Best Photo lib"
fi

# Vendor lib info checks
MAIN_CAMERA_CONFIG_VENDOR_LIB_INFO="$(GET_FF_VAL "main" "SEC_FLOATING_FEATURE_CAMERA_CONFIG_VENDOR_LIB_INFO")"
STOCK_CAMERA_CONFIG_VENDOR_LIB_INFO="$(GET_FF_VAL "stock" "SEC_FLOATING_FEATURE_CAMERA_CONFIG_VENDOR_LIB_INFO")"

# Example: AEBHDR
if [[ "$MAIN_CAMERA_CONFIG_VENDOR_LIB_INFO" == *"aebhdr.arcsoft.v1"* ]] && \
   [[ "$STOCK_CAMERA_CONFIG_VENDOR_LIB_INFO" != *"aebhdr.arcsoft.v1"* ]]; then
    SILENT REMOVE "system" "lib64/libAEBHDR_wrapper.camera.samsung.so"
    SILENT REMOVE "system" "lib64/libae_bracket_hdr.arcsoft.so"
    LOG_INFO "Removed AEBHDR libs"
fi

# DualCam Bokeh
if [[ -f "$WORKSPACE/vendor/lib64/libDualCamBokehCapture.camera.samsung.so" ]] || {
    [[ "$MAIN_CAMERA_CONFIG_VENDOR_LIB_INFO" == *"dual_bokeh.samsung"* ]] && \
    [[ "$STOCK_CAMERA_CONFIG_VENDOR_LIB_INFO" != *"dual_bokeh.samsung"* ]]
}; then
    SILENT REMOVE "system" "lib64/libDualCamBokehCapture.camera.samsung.so"
    SILENT REMOVE "system" "lib64/libarcsoft_dualcam_portraitlighting.so"
    SILENT REMOVE "system" "lib64/libarcsoft_single_cam_glasses_seg.so"
    SILENT REMOVE "system" "lib64/libarcsoft_superresolution_bokeh.so"
    SILENT REMOVE "system" "lib64/libdualcam_refocus_image.so"
    SILENT REMOVE "system" "lib64/libhigh_dynamic_range_bokeh.so"
    LOG_INFO "Removed DualCam Bokeh libs"
fi

# Additional cleanup blocks should follow the same pattern only when the target lib exists.
# This keeps the script stable and source-compatible with the project conventions.

LOG_END "Camera libs debloated successfully."
