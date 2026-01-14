#!/bin/bash

# ==============================================================================
# Bağımlılık Kontrolü
# ==============================================================================

check_dependencies() {
    local missing_deps=()

    # Pandoc (Çekirdek)
    if ! command -v pandoc &> /dev/null; then
        missing_deps+=("pandoc")
    fi

    # Arayüz araçları (En az biri olmalı, ancak app.sh moduna göre değişir)
    # Burada sadece pandoc'un varlığı kritik. Arayüz araçları app.sh içinde yönetilir.
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "KRİTİK HATA: Aşağıdaki bağımlılıklar eksik:"
        printf ' - %s\n' "${missing_deps[@]}"
        echo "Lütfen 'sudo apt install pandoc' komutu ile yükleyiniz."
        exit 1
    fi

    log_info "Tüm kritik bağımlılıklar mevcut."
}
