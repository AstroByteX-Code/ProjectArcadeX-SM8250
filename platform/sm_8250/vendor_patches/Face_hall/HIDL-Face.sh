# ==============================================================================
# Patch: HIDL Face Biometrics Injection
# Context:
#   - Injects HIDL face biometrics libraries from r9q donor
#   - Registers SELinux contexts
# ==============================================================================

# --------------------------------------------------------------------------
# Inject HIDL face biometrics libs
# --------------------------------------------------------------------------
LOG_BEGIN "Injecting HIDL face biometrics libraries from r9qxxx donor..."

ADD_FROM_FW "r9q" "system" "system/lib/android.hardware.biometrics.face@1.0.so"
ADD_CONTEXT "system" "system/lib/android.hardware.biometrics.face@1.0.so" "system_file"

ADD_FROM_FW "r9q" "system" "system/lib/vendor.samsung.hardware.biometrics.face@2.0.so"
ADD_CONTEXT "system" "system/lib/vendor.samsung.hardware.biometrics.face@2.0.so" "system_file"

LOG_END "HIDL face biometrics libraries injection complete"

