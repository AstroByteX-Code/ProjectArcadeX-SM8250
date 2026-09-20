# ==============================================================================
# Patch: Fix Wi‑Fi HAL (AstroROM style)
# Context:
#   - Removes outdated Wi‑Fi service binaries
#   - Injects stable blobs from y2q firmware
#   - Ensures proper Wi‑Fi service initialization and stability
# ==============================================================================

LOG_BEGIN "Fixing Wi‑Fi..."

# Remove old Wi‑Fi service binaries
SILENT REMOVE "vendor" "bin/hw/wpa_supplicant"
LOG_INFO "Removed outdated Wi‑Fi service binaries"

# Inject stable Wi‑Fi blobs from y2q firmware
ADD_FROM_FW "y2q" "vendor" "bin/hw/wpa_supplicant"
LOG_INFO "Injected Wi‑Fi service binaries from y2q firmware"

LOG_END "Wi‑Fi HAL fix applied successfully"
