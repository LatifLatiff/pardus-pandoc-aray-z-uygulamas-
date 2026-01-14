#!/bin/bash

# ==============================================================================
# Genel Yardımcı Fonksiyonlar ve Ayarlar
# ==============================================================================

# Katı Mod
set -euo pipefail
IFS=$'\n\t'

# Geçici Dosya Yönetimi
TEMP_DIR="/tmp/pandoc-frontend-$USER"
mkdir -p "$TEMP_DIR"

cleanup() {
    # Geçici dosyaları temizle
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
    log_info "Uygulama kapatıldı, temizlik yapıldı."
}

# Dosya uzantısını alma
get_extension() {
    local filename=$(basename "$1")
    echo "${filename##*.}"
}

# Dosya adını uzantısız alma
get_filename_no_ext() {
    local filename=$(basename "$1")
    echo "${filename%.*}"
}
