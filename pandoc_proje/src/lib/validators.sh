#!/bin/bash

# ==============================================================================
# Doğrulama Fonksiyonları
# ==============================================================================

validate_input_file() {
    local file="$1"
    
    if [[ -z "$file" ]]; then
        log_error "Girdi dosyası seçilmedi."
        return 1
    fi

    if [[ ! -f "$file" ]]; then
        log_error "Dosya bulunamadı: $file"
        return 1
    fi

    local ext
    ext=$(get_extension "$file")
    
    # Desteklenen format kontrolü
    local valid=false
    for fmt in "${SUPPORTED_INPUTS[@]}"; do
        if [[ "$fmt" == "$ext" ]]; then
            valid=true
            break
        fi
    done

    if [[ "$valid" == "false" ]]; then
        log_error "Desteklenmeyen girdi formatı: .$ext"
        return 1
    fi

    return 0
}

validate_output_dir() {
    local out_file="$1"
    local dir_name
    dir_name=$(dirname "$out_file")

    if [[ ! -w "$dir_name" ]]; then
        log_error "Çıktı dizinine yazma izni yok: $dir_name"
        return 1
    fi
    return 0
}
