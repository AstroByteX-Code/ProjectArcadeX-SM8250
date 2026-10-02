#!/bin/bash
# ==============================================================================
# Patch: FSTAB.qcom Cleanup (ext4/erofs aware)
# Author: Code_by_Mian
# Context:
#   - Detects target filesystem type (ext4/erofs)
#   - Ensures system keeps ext4/f2fs, adds erofs ro if needed
#   - Forces product/vendor/odm to erofs ro when erofs is detected
# ==============================================================================

PARTITIONS_LIST="system vendor product system_ext odm vendor_dlkm odm_dlkm system_dlkm"
FILE_SYSTEM_TYPE="${FILE_SYSTEM_TYPE:-${FILESYSTEM:-ext4}}"
FILE_SYSTEM_TYPE="${FILE_SYSTEM_TYPE,,}"
TMP_DIR="${WORKSPACE}/.tmp_filesystem_$$"

# --------------------------------------------------------------------------
# Detect filesystem type automatically
# --------------------------------------------------------------------------
DETECT_TARGET_FILESYSTEM() {
    local CANDIDATE="${1:-}"
    local IMG FS

    if [[ -n "$CANDIDATE" ]]; then
        echo "${CANDIDATE,,}"
        return 0
    fi

    for IMG in "$WORKSPACE/out"/*.img "$WORKSPACE/out"/boot.img "$WORKSPACE/out"/vendor_boot.img; do
        [[ -f "$IMG" ]] || continue

        FS=$(blkid -o value -s TYPE "$IMG" 2>/dev/null || true)
        if [[ -n "$FS" ]]; then
            echo "${FS,,}"
            return 0
        fi

        # Detect EROFS magic
        if [[ "$(xxd -p -l 4 -s 1024 "$IMG" 2>/dev/null)" == "e0f5e1e2" ]]; then
            echo "erofs"
            return 0
        fi
    done

    echo "ext4"
}

# --------------------------------------------------------------------------
# Patch fstab entries
# --------------------------------------------------------------------------
PATCH_FSTAB() {
    mkdir -p "$TMP_DIR"   # ensure temp dir exists
    local f
    while IFS= read -r f; do
        if [[ "$f" == *"emmc" ]] || [[ "$f" == *"ramplus" ]]; then
            continue
        fi

        if [[ "$FILE_SYSTEM_TYPE" == "erofs" ]]; then
            # Ensure system has erofs ro entry, but keep ext4/f2fs lines
            grep -q "^system[[:space:]]\+/system[[:space:]]\+erofs" "$f" || \
                echo -e "system\t/system\terofs\tro\twait,avb=vbmeta,logical,first_stage_mount,avb_keys=/avb/q-gsi.avbpubkey:/avb/r-gsi.avbpubkey:/avb/s-gsi.avbpubkey" >> "$f"

            # Force product/vendor/odm to erofs ro
            sed -E -i \
                -e "/^(product|vendor|odm)[[:space:]]+/ s/^([^[:space:]]+[[:space:]]+[^[:space:]]+)[[:space:]]+[^[:space:]]+[[:space:]]+/\\1\terofs\tro\t/" \
                "$f"

            LOG_INFO "Patched $(basename "$f") with erofs ro (system keeps ext4/f2fs)"
        else
            # Default ext4 patch for all partitions
            sed -E -i \
                -e "/^[^[:space:]]+[[:space:]]+\/(${PARTITIONS_LIST// /|})[[:space:]]+/ s/^([^[:space:]]+[[:space:]]+[^[:space:]]+)[[:space:]]+[^[:space:]]+[[:space:]]+/\1\t$FILE_SYSTEM_TYPE\t/" \
                -e "/^[^[:space:]]+[[:space:]]+\/(${PARTITIONS_LIST// /|})[[:space:]]+/ s/^([^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+)[[:space:]]+[^[:space:]]+[[:space:]]+/\1\tro\t/" \
                "$f"
            LOG_INFO "Patched $(basename "$f") with ${FILE_SYSTEM_TYPE}"
        fi

        # Deduplicate safely
        uniq "$f" > "$TMP_DIR/tmp" && mv -f "$TMP_DIR/tmp" "$f"
    done < <(find "$1" -type f -name "fstab.*")
}

# --------------------------------------------------------------------------
# Run patch
# --------------------------------------------------------------------------
LOG_BEGIN "Patching fstab.qcom"

FILE_SYSTEM_TYPE="$(DETECT_TARGET_FILESYSTEM "${FILESYSTEM:-}")"
PATCH_FSTAB "$WORKSPACE/vendor/etc"

rm -rf "$TMP_DIR"

LOG_END "fstab.qcom patch complete"

unset PARTITIONS_LIST FILE_SYSTEM_TYPE TMP_DIR
unset -f PATCH_FSTAB DETECT_TARGET_FILESYSTEM
