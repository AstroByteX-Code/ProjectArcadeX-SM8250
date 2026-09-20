# ==============================================================================
# Patch: SoundBooster / SoundAlive Cleanup and Injection
#   - Removes conflicting audio HAL blobs
#   - Injects legacy SoundBooster and SoundAlive libraries from stock firmware
#   - Registers SELinux contexts
# ==============================================================================

# --------------------------------------------------------------------------
# Remove conflicting audio HAL blobs
# --------------------------------------------------------------------------
LOG_BEGIN "Removing vendor audio HAL blobs..."

SILENT REMOVE "vendor" "lib/android.hardware.audio.common@5.0-util.so"
SILENT REMOVE "vendor" "lib/hw/android.hardware.audio.effect@5.0-impl.so"
SILENT REMOVE "vendor" "lib/hw/android.hardware.audio@5.0-impl.so"
SILENT REMOVE "vendor" "lib64/android.hardware.audio.common@5.0-util.so"
SILENT REMOVE "vendor" "lib64/hw/android.hardware.audio.effect@5.0-impl.so"
SILENT REMOVE "vendor" "lib64/hw/android.hardware.audio@5.0-impl.so"

LOG_END "Vendor audio HAL cleanup complete"

# --------------------------------------------------------------------------
# Inject SoundBooster / SoundAlive libraries
# --------------------------------------------------------------------------
LOG_BEGIN "Injecting stock SoundBooster and SoundAlive libraries..."

ADD_FROM_FW "stock" "system" "system/lib/lib_SoundBooster_ver1050.so"
ADD_CONTEXT "system" "system/lib/lib_SoundBooster_ver1050.so" "system_file"
SILENT REMOVE "system" "system/lib/lib_SoundBooster_ver1100.so"

ADD_FROM_FW "stock" "system" "system/lib/lib_SoundAlive_play_plus_ver400.so"
ADD_CONTEXT "system" "system/lib/lib_SoundAlive_play_plus_ver400.so" "system_file"
SILENT REMOVE "system" "system/lib/lib_SoundAlive_play_plus_ver800.so"

ADD_FROM_FW "stock" "system" "system/lib/libaudiosaplus_sec_legacy.so"
ADD_CONTEXT "system" "system/lib/libaudiosaplus_sec_legacy.so" "system_file"

ADD_FROM_FW "stock" "system" "system/lib/libsamsungSoundbooster_plus_legacy.so"
ADD_CONTEXT "system" "system/lib/libsamsungSoundbooster_plus_legacy.so" "system_file"

ADD_FROM_FW "stock" "system" "system/lib64/lib_SoundBooster_ver1050.so"
ADD_CONTEXT "system" "system/lib64/lib_SoundBooster_ver1050.so" "system_file"
SILENT REMOVE "system" "system/lib64/lib_SoundBooster_ver1100.so"

ADD_FROM_FW "stock" "system" "system/lib64/lib_SoundAlive_play_plus_ver400.so"
ADD_CONTEXT "system" "system/lib64/lib_SoundAlive_play_plus_ver400.so" "system_file"
SILENT REMOVE "system" "system/lib64/lib_SoundAlive_play_plus_ver800.so"

ADD_FROM_FW "stock" "system" "system/lib64/libaudiosaplus_sec_legacy.so"
ADD_CONTEXT "system" "system/lib64/libaudiosaplus_sec_legacy.so" "system_file"

ADD_FROM_FW "stock" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so"
ADD_CONTEXT "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" "system_file"

LOG_END "SoundBooster / SoundAlive patch applied successfully"
