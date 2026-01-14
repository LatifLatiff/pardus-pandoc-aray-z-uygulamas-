#!/bin/bash

# ==============================================================================
# Çekirdek İş Mantığı (Pandoc Komut İnşası) - FIX: Variable Scope
# ==============================================================================

# Global değişken (Hata almamak için boş tanımlıyoruz)
CURRENT_OUTPUT=""
PANDOC_CMD=()

# Komut oluşturucu
build_pandoc_cmd() {
    # Argümanları al
    local input_file="$1"
    local output_file="$2"
    local toc="$3"              # TRUE/FALSE
    local standalone="$4"       # TRUE/FALSE
    local num_sections="$5"     # TRUE/FALSE
    local highlight="$6"        # style name or empty
    local title="$7"
    local author="$8"
    local css_file="$9"
    
    # Global değişkene ata ki run_pandoc bunu görebilsin
    CURRENT_OUTPUT="$output_file"

    # Temel komut
    PANDOC_CMD=("pandoc" "$input_file" "-o" "$output_file")

    # Opsiyonlar
    if [[ "$toc" == "TRUE" ]]; then
        PANDOC_CMD+=("--toc")
    fi

    if [[ "$standalone" == "TRUE" ]]; then
        PANDOC_CMD+=("--standalone")
    fi

    if [[ "$num_sections" == "TRUE" ]]; then
        PANDOC_CMD+=("--number-sections")
    fi

    if [[ -n "$highlight" ]]; then
        PANDOC_CMD+=("--highlight-style=$highlight")
    fi

    # Metadata
    if [[ -n "$title" ]]; then
        PANDOC_CMD+=("--metadata" "title=$title")
    fi

    if [[ -n "$author" ]]; then
        PANDOC_CMD+=("--metadata" "author=$author")
    fi
    
    # CSS (Sadece HTML/EPUB için mantıklı)
    if [[ -n "$css_file" && -f "$css_file" ]]; then
         PANDOC_CMD+=("--css=$css_file")
    fi
}

# Komutu Çalıştır
run_pandoc() {
    log_info "Komut çalıştırılıyor: ${PANDOC_CMD[*]}"
    
    # Çıktı dosyalarını sıfırla
    : > "$LAST_RUN_OUT"
    : > "$LAST_RUN_ERR"

    # Çalıştır
    if "${PANDOC_CMD[@]}" > "$LAST_RUN_OUT" 2> "$LAST_RUN_ERR"; then
        # HATA BURADAYDI: $output_file yerine $CURRENT_OUTPUT kullanıyoruz
        log_info "Dönüştürme başarılı: $CURRENT_OUTPUT"
        return 0
    else
        log_error "Dönüştürme başarısız. Detaylar için loglara bakın."
        return 1
    fi
}
