#!/bin/bash

# ==============================================================================
# Linux Scriptleri ve Araçları Dersi - Dönem Projesi
# Pandoc Frontend (GUI & TUI)
# ==============================================================================

# Dizinleri Ayarla
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

# Kütüphaneleri Yükle
source "$LIB_DIR/logging.sh"
source "$LIB_DIR/config.sh"
source "$LIB_DIR/common.sh"
source "$LIB_DIR/deps.sh"
source "$LIB_DIR/presets.sh"
source "$LIB_DIR/validators.sh"
source "$LIB_DIR/core.sh"
source "$LIB_DIR/gui.sh"
source "$LIB_DIR/tui.sh"

# Global Ayarlar
init_logging
load_config
check_dependencies

# Yardım Fonksiyonu
show_help() {
    echo "Kullanım: $(basename "$0") [SEÇENEKLER]"
    echo
    echo "Seçenekler:"
    echo "  --gui       Grafik arayüzü zorla (YAD)"
    echo "  --tui       Terminal arayüzü zorla (Whiptail)"
    echo "  --help      Bu yardım mesajını gösterir"
    echo
    echo "Varsayılan: GUI mevcutsa GUI, değilse TUI açılır."
}

# Ana Çalıştırma Mantığı
main() {
    local mode="auto"

    # Argümanları İşle
    while [[ $# -gt 0 ]]; do
        case $1 in
            --gui)
                mode="gui"
                shift
                ;;
            --tui)
                mode="tui"
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo "Hata: Bilinmeyen argüman '$1'"
                show_help
                exit 1
                ;;
        esac
    done

    # Mod Seçimi
    if [[ "$mode" == "auto" ]]; then
        if command -v yad &> /dev/null && [[ -n "$DISPLAY" ]]; then
            mode="gui"
        else
            mode="tui"
        fi
    fi

    log_info "Uygulama başlatıldı. Mod: $mode"

    # Uygulamayı Başlat
    if [[ "$mode" == "gui" ]]; then
        if ! command -v yad &> /dev/null; then
            echo "Hata: GUI modu istendi ancak 'yad' yüklü değil."
            exit 1
        fi
        start_gui
    else
        start_tui
    fi
}

# Hata yakalama ve temizlik
trap cleanup EXIT

# Başlat
main "$@"
