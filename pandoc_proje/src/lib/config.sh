#!/bin/bash

# ==============================================================================
# Ayar Yönetimi (Persistence)
# ==============================================================================

CONFIG_DIR="$HOME/.config/pandoc-frontend"
CONFIG_FILE="$CONFIG_DIR/settings.conf"

# Varsayılan Değerler
DEFAULT_DIR="$HOME/Documents"
DEFAULT_AUTHOR=""
DEFAULT_TOC="FALSE"
DEFAULT_NUMSEC="FALSE"
DEFAULT_STANDALONE="TRUE"

load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
        log_info "Ayarlar yüklendi."
    else
        log_info "Ayar dosyası bulunamadı, varsayılanlar kullanılacak."
    fi
}

save_config() {
    local dir="$1"
    local author="$2"
    local toc="$3"
    local numsec="$4"
    local standalone="$5"

    mkdir -p "$CONFIG_DIR"

    cat <<EOF > "$CONFIG_FILE"
DEFAULT_DIR="$dir"
DEFAULT_AUTHOR="$author"
DEFAULT_TOC="$toc"
DEFAULT_NUMSEC="$numsec"
DEFAULT_STANDALONE="$standalone"
EOF
    log_info "Ayarlar kaydedildi."
}
