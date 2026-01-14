#!/bin/bash

# ==============================================================================
# Format ve Uzantı Tanımları (IFS Düzeltmesi Uygulandı)
# ==============================================================================

# Desteklenen Girdi Formatları
SUPPORTED_INPUTS=("md" "docx" "html" "htm" "tex" "rst")

# Desteklenen Çıktı Formatları
SUPPORTED_OUTPUTS=("pdf" "docx" "html" "md" "epub")

# Format Listesini String Olarak Al (TUI/Validasyon için)
get_input_formats_str() {
    # Geçici olarak IFS'yi boşluk yapıyoruz ki array düzgün birleşsin
    ( IFS=' '; echo "${SUPPORTED_INPUTS[*]}" | tr ' ' '!' )
}

get_output_formats_str() {
    ( IFS=' '; echo "${SUPPORTED_OUTPUTS[*]}" | tr ' ' '!' )
}

# GUI (YAD) İçin Özel Format Listesi
get_output_formats_yad() {
    # 1. ( IFS=' ' ) -> Array elemanlarını boşlukla birleştirmesini garantiler.
    # 2. tr ' ' '!'  -> Boşlukları YAD'ın anladığı ünlem (!) işaretine çevirir.
    # 3. "^"         -> Listenin başına şapka koyarak ilk elemanın (pdf) seçili gelmesini sağlar.
    local list
    list=$( IFS=' '; echo "${SUPPORTED_OUTPUTS[*]}" | tr ' ' '!' )
    echo "^$list"
}
