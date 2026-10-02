# ==============================================================================
#
# MOD_NAME="Debloat useless apps"
# MOD_AUTHOR="ShaDisNX255"
# MOD_DESC="Debloats non needed apps and files from ROM."
#
# ==============================================================================


#  OVERLAYS
BLOAT_TARGETS+=(
    "WifiRROverlayAppH2E"
    "WifiRROverlayAppLls"
)

SILENT REMOVE "system" "bin/mafpc_write"

BLOAT_TARGETS+=(
    "GlobalPostProcMgr"
	"PetService"
	"VideoScan"
	"SohService"
)

SILENT REMOVE "system" "etc/default-permissions/default-permissions-com.samsung.android.globalpostprocmgr.xml"
SILENT REMOVE "system" "etc/default-permissions/default-permissions-com.samsung.petservice.xml"
SILENT REMOVE "system" "etc/default-permissions/default-permissions-com.samsung.videoscan.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.android.globalpostprocmgr.xml"	
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.petservice.xml"
SILENT REMOVE "system" "etc/permissions/privapp-permissions-com.samsung.videoscan.xml"

BLOAT_TARGETS+=(
	"com.qualcomm.location"
)

SILENT REMOVE "system" "system_ext/etc/permissions/com.qti.location.sdk.xml"
SILENT REMOVE "system" "system_ext/etc/permissions/com.qualcomm.location.xml"
SILENT REMOVE "system" "system_ext/etc/etc/permissions/privapp-permissions-com.qualcomm.location.xml"
SILENT REMOVE "system" "system_ext/framework/com.qti.location.sdk.jar"

NUKE_BLOAT "${BLOAT_TARGETS[@]}"

LOG_END "Debloated successfully"
