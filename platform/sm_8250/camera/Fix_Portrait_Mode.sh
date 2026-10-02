# ==============================================================================
# Patch: Fix portrait mode (AstroROM style)
# Context:
#   - Uses the repo's supported binary patch helper
#   - Copies the stock build flavor property
#   - Patches camera libs to reference ro.astro.codename instead of ro.product.name
# ==============================================================================

LOG_BEGIN "Fixing portrait mode for camera..."

BPROP_IF_DIFF "stock" "system" "ro.build.flavor" "system"

if [[ -f "$WORKSPACE/vendor/lib64/libDualCamBokehCapture.camera.samsung.so" ]]; then
    LOG_INFO "Applying HEX edits to camera libs"
    HEX_EDIT "vendor/lib/libDualCamBokehCapture.camera.samsung.so" \
        "726f2e70726f647563742e6e616d6500" "726f2e617374726f2e636f64656e616d6500"
    HEX_EDIT "vendor/lib/liblivefocus_capture_engine.so" \
        "726f2e70726f647563742e6e616d6500" "726f2e617374726f2e636f64656e616d6500"
    HEX_EDIT "vendor/lib/liblivefocus_preview_engine.so" \
        "726f2e70726f647563742e6e616d6500" "726f2e617374726f2e636f64656e616d6500"
    HEX_EDIT "vendor/lib64/libDualCamBokehCapture.camera.samsung.so" \
        "726f2e70726f647563742e6e616d6500" "726f2e617374726f2e636f64656e616d6500"
    HEX_EDIT "vendor/lib64/liblivefocus_capture_engine.so" \
        "726f2e70726f647563742e6e616d6500" "726f2e617374726f2e636f64656e616d6500"
    HEX_EDIT "vendor/lib64/liblivefocus_preview_engine.so" \
        "726f2e70726f647563742e6e616d6500" "726f2e617374726f2e636f64656e616d6500"
else
    LOG_INFO "Skipping: libDualCamBokehCapture.camera.samsung.so not found"
fi

LOG_END "Portrait mode fix applied successfully"
