LOG_BEGIN "Adding GameDriver..."

# Add GameDriver package
ADD_FROM_FW "stock" "system" "priv-app/GameDriver-SM8250"
LOG_INFO "Injected GameDriver package from stock firmware"

LOG_END "GameDriver patch applied successfully"

# Remove outdated 64‑bit WFD/HDCP libs
REMOVE "system" "lib64/libhdcp_client_aidl.so"
REMOVE "system" "lib64/libhdcp2.so"
REMOVE "system" "lib64/libremotedisplay_wfd.so"
REMOVE "system" "lib64/libremotedisplayservice.so"
REMOVE "system" "lib64/libsecuibc.so"
REMOVE "system" "lib64/libstagefright_hdcp.so"
REMOVE "system" "lib64/vendor.samsung.hardware.security.hdcp.wifidisplay-V2-ndk.so"
REMOVE "system" "lib64/wfd_log.so"
LOG_INFO "Removed outdated 64‑bit WFD/HDCP libraries"

# Inject 32‑bit WFD stack from r9q firmware
ADD_FROM_FW "r9q" "system" "bin/insthk"
ADD_CONTEXT "system" "bin/insthk" "insthk_exec"

ADD_FROM_FW "r9q" "system" "bin/remotedisplay"
ADD_CONTEXT "system" "bin/remotedisplay" "remotedisplay_exec"

ADD_FROM_FW "r9q" "system" "lib/libhdcp2.so"
ADD_CONTEXT "system" "lib/libhdcp2.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/libremotedisplay_wfd.so"
ADD_CONTEXT "system" "lib/libremotedisplay_wfd.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/libremotedisplayservice.so"
ADD_CONTEXT "system" "lib/libremotedisplayservice.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/libsecuibc.so"
ADD_CONTEXT "system" "lib/libsecuibc.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/libstagefright_hdcp.so"
ADD_CONTEXT "system" "lib/libstagefright_hdcp.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/wfd_log.so"
ADD_CONTEXT "system" "lib/wfd_log.so" "system_lib_file"

LOG_END "32‑bit WFD patch applied successfully"

LOG_BEGIN "Adding Stock Google Blobs..."

# Replace Google Hotword Enrollment blobs
NUKE_BLOAT "product" "priv-app/HotwordEnrollmentOKGoogleEx4HEXAGON"
NUKE_BLOAT "product" "priv-app/HotwordEnrollmentXGoogleEx4HEXAGON"
LOG_INFO "Removed outdated Google HotwordEnrollment blobs"

ADD_FROM_FW "a73" "product" "priv-app/HotwordEnrollmentOKGoogleEx3HEXAGON"
ADD_FROM_FW "a73" "product" "priv-app/HotwordEnrollmentXGoogleEx3HEXAGON"
LOG_INFO "Injected stock Google HotwordEnrollment blobs from dm3q firmware"

LOG_END "Google blobs patch applied successfully"

LOG_BEGIN "Fixing Wireless Charge..."

# Add wireless charge cover app and permissions
ADD_FROM_FW "stock" "system" "priv-app/LedBackCoverAppHubble"
ADD_FROM_FW "stock" "system" "etc/permissions/privapp-permissions-com.samsung.android.app.ledbackcover.xml"
LOG_INFO "Injected LedBackCoverAppHubble and permissions"

# Remove outdated cover permissions
SILENT REMOVE "system" "etc/permissions/com.sec.feature.cover.clearcameraviewcover.xml"
SILENT REMOVE "system" "etc/permissions/com.sec.feature.cover.flip.xml"
SILENT REMOVE "system" "etc/permissions/com.sec.feature.pocketsensitivitymode_level1.xml"
LOG_INFO "Removed outdated cover feature permissions"

# Add updated cover permission
ADD_FROM_FW "stock" "system" "etc/permissions/com.sec.feature.cover.clearsideviewcover.xml"
LOG_INFO "Injected updated clearsideviewcover permission"

LOG_END "Wireless Charge patch applied successfully"

LOG_BEGIN "Adding libhwui from r9q..."

# Add libhwui from r9q firmware
ADD_FROM_FW "r9q" "system" "lib/libhwui.so"
ADD_FROM_FW "r9q" "system" "lib64/libhwui.so"
LOG_INFO "Injected libhwui (32‑bit and 64‑bit) from r9q firmware"

LOG_END "libhwui patch applied successfully"

LOG_BEGIN "Adding r9q Keymaster libs..."

# Remove KeyMint/secureclock stubs
REMOVE "system" "lib/android.hardware.security.secureclock-V1-ndk.so"
REMOVE "system" "lib/libdk_native_keymint.so"
REMOVE "system" "lib64/libdk_native_keymint.so"
LOG_INFO "Removed KeyMint and secureclock stubs"

# Inject keymaster libs from r9q firmware
ADD_FROM_FW "r9q" "system" "lib/android.hardware.keymaster@3.0.so"
ADD_CONTEXT "system" "lib/android.hardware.keymaster@3.0.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/android.hardware.keymaster@4.0.so"
ADD_CONTEXT "system" "lib/android.hardware.keymaster@4.0.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/android.hardware.keymaster@4.1.so"
ADD_CONTEXT "system" "lib/android.hardware.keymaster@4.1.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/lib_nativeJni.dk.samsung.so"
ADD_CONTEXT "system" "lib/lib_nativeJni.dk.samsung.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/libdk_native_keymaster.so"
ADD_CONTEXT "system" "lib/libdk_native_keymaster.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/libkeymaster4_1support.so"
ADD_CONTEXT "system" "lib/libkeymaster4_1support.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/libkeymaster4support.so"
ADD_CONTEXT "system" "lib/libkeymaster4support.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib64/lib_nativeJni.dk.samsung.so"
ADD_CONTEXT "system" "lib64/lib_nativeJni.dk.samsung.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib64/libdk_native_keymaster.so"
ADD_CONTEXT "system" "lib64/libdk_native_keymaster.so" "system_lib_file"

LOG_END "r9q Keymaster patch applied successfully"

LOG_BEGIN "Adding pa1q NFC blobs..."

# Remove outdated NFC JNI blob
SILENT REMOVE "system" "lib64/libnfc_nxpsn_jni.so"
LOG_INFO "Removed outdated libnfc_nxpsn_jni.so"

# Inject NFC libs from pa1q firmware
ADD_FROM_FW "pa1q" "system" "lib64/libnfc_sec_jni.so"
ADD_FROM_FW "pa1q" "system" "lib64/libnfc-nci_flags.so"
ADD_FROM_FW "pa1q" "system" "lib64/libnfc-sec.so"
ADD_FROM_FW "pa1q" "system" "lib64/libstatslog_nfc.so"
LOG_INFO "Injected NFC libraries from pa1q firmware"

# Restore NFC‑related cover permissions from stock firmware
ADD_FROM_FW "stock" "system" "etc/permissions/com.sec.feature.cover.clearsideviewcover.xml"
ADD_FROM_FW "stock" "system" "etc/permissions/com.sec.feature.cover.xml"
ADD_FROM_FW "stock" "system" "etc/permissions/com.sec.feature.cover.sview.xml"
ADD_FROM_FW "stock" "system" "etc/permissions/com.sec.feature.nfc_authentication_cover.xml"
LOG_INFO "Restored NFC‑related cover permissions from stock firmware"

# Register context for injected NFC libs
ADD_CONTEXT "system" "lib64/libnfc_sec_jni.so" "system_file"
ADD_CONTEXT "system" "lib64/libnfc-nci_flags.so" "system_file"
ADD_CONTEXT "system" "lib64/libnfc-sec.so" "system_file"
ADD_CONTEXT "system" "lib64/libstatslog_nfc.so" "system_file"
ADD_CONTEXT "system" "etc/permissions/com.sec.feature.cover.clearsideviewcover.xml" "system_file"
ADD_CONTEXT "system" "etc/permissions/com.sec.feature.cover.xml" "system_file"
ADD_CONTEXT "system" "etc/permissions/com.sec.feature.cover.sview.xml" "system_file"
ADD_CONTEXT "system" "etc/permissions/com.sec.feature.nfc_authentication_cover.xml" "system_file"
LOG_INFO "Registered NFC blobs and cover permissions in AstroROM context"

LOG_END "pa1q NFC patch applied successfully"

# HIDL face biometrics libs
ADD_FROM_FW "r9q" "system" "lib/android.hardware.biometrics.face@1.0.so"
ADD_CONTEXT "system" "lib/android.hardware.biometrics.face@1.0.so" "system_lib_file"

ADD_FROM_FW "r9q" "system" "lib/vendor.samsung.hardware.biometrics.face@2.0.so"
ADD_CONTEXT "system" "lib/vendor.samsung.hardware.biometrics.face@2.0.so" "system_lib_file"

LOG_END "Stock blob compatibility patch applied successfully."
