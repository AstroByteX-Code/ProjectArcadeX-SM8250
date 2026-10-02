# ==============================================================================
# Patch: NFC Libraries and Config Injection
# Author: @salvogiangri
# Context:
#   - Cleans up outdated NFC configs/libs
#   - Injects correct NFC configs and libraries from stock firmware
# ==============================================================================

# --------------------------------------------------------------------------
# NFC Config Files
# --------------------------------------------------------------------------
if [ -f "$STOCK_FW/system/system/etc/libnfc-nci.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci.conf"
    LOG_INFO "Injected libnfc-nci.conf from stock"
else
    REMOVE "system" "etc/libnfc-nci.conf"
    LOG_INFO "Removed libnfc-nci.conf"
fi

if [ -f "$STOCK_FW/system/system/etc/libnfc-nci_temp.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci_temp.conf"
    LOG_INFO "Injected libnfc-nci_temp.conf from stock"
else
    REMOVE "system" "etc/libnfc-nci_temp.conf"
    LOG_INFO "Removed libnfc-nci_temp.conf"
fi

if [ -f "$STOCK_FW/system/system/etc/libnfc-nci-NXP_SN100U.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci-NXP_SN100U.conf"
    LOG_INFO "Injected libnfc-nci-NXP_SN100U.conf"
fi

if [ -f "$STOCK_FW/system/system/etc/libnfc-nci-NXP_PN553.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci-NXP_PN553.conf"
    LOG_INFO "Injected libnfc-nci-NXP_PN553.conf"
fi

if [ -f "$STOCK_FW/system/system/etc/libnfc-nci-SLSI.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci-SLSI.conf"
    LOG_INFO "Injected libnfc-nci-SLSI.conf"
fi

if [ -f "$STOCK_FW/system/system/etc/libnfc-nci-STM_ST21.conf" ]; then
    ADD_FROM_FW "stock" "system" "etc/libnfc-nci-STM_ST21.conf"
    LOG_INFO "Injected libnfc-nci-STM_ST21.conf"
fi

# --------------------------------------------------------------------------
# NFC Chip Property
# --------------------------------------------------------------------------
CHIP_NAME="$(GET_PROP "vendor" "ro.vendor.nfc.feature.chipname" "stock")"
if [ "$CHIP_NAME" ]; then
    if [[ "$CHIP_NAME" == "NXP_PN553" ]]; then
        BPROP "vendor" "ro.vendor.nfc.feature.chipname" "NXP_SN100U"
        CHIP_NAME="NXP_SN100U"
        LOG_INFO "Patched NFC chip property from NXP_PN553 → NXP_SN100U"
    fi
    if ! [[ "$CHIP_NAME" =~ NXP_SN100U|SLSI|STM_ST21 ]]; then
        LOG_WARN "Unknown NFC chip name: $CHIP_NAME"
        return 0
    else
        LOG_INFO "Detected NFC chip: $CHIP_NAME"
    fi
fi

# --------------------------------------------------------------------------
# Architecture Blocks
# --------------------------------------------------------------------------
# 32-bit NXP
if [ -f "$WORKSPACE/system/system/lib/libnfc_nci_jni.so" ]; then
    if [ ! -f "$STOCK_FW/system/system/lib/libnfc_nci_jni.so" ] && \
       [ ! -f "$STOCK_FW/system/system/lib/libnfc_nxppn_jni.so" ] && \
       [ ! -f "$STOCK_FW/system/system/lib/libnfc_nxpsn_jni.so" ]; then
        REMOVE "system" "lib/libnfc_nci_jni.so"
        REMOVE "system" "lib/libnfc_prop_extn.so"
        REMOVE "system" "lib/libnfc_vendor_extn.so"
        LOG_INFO "Removed unsupported 32-bit NXP NFC libs"
    fi
elif [ -f "$STOCK_FW/system/system/lib/libnfc_nci_jni.so" ]; then
    ADD_FROM_FW "stock" "system" "lib/libnfc_nci_jni.so"
    ADD_FROM_FW "stock" "system" "lib/libnfc_prop_extn.so"
    ADD_FROM_FW "stock" "system" "lib/libnfc_vendor_extn.so"
    LOG_INFO "Injected 32-bit NXP NFC libs from stock"
elif [ -f "$STOCK_FW/system/system/lib/libnfc_nxpsn_jni.so" ]; then
    LOG_WARN "Missing prebuilt blobs for 32-bit NXP_SN100U NFC chip"
    return 0
fi
