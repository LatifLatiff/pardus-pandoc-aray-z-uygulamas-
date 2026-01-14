#!/bin/bash

# ==============================================================================
# Terminal Arayüz (Whiptail) - Varsayılan Sistem Teması
# ==============================================================================

start_tui() {
    # 1. Girdi Dosyası Seçimi
    local input_file
    input_file=$(whiptail --title "Girdi Dosyası" --inputbox "Dönüştürülecek dosyanın tam yolunu giriniz:" 10 70 "$PWD/" 3>&1 1>&2 2>&3)
    
    # İptal kontrolü
    if [[ $? -ne 0 ]]; then exit 0; fi

    # Doğrulama
    if ! validate_input_file "$input_file"; then
        whiptail --msgbox "Hata: Geçersiz dosya veya desteklenmeyen format!" 10 60
        start_tui; return
    fi

    # 2. Çıktı Formatı
    local out_fmt
    out_fmt=$(whiptail --title "Çıktı Formatı" --menu "Format Seçiniz" 15 60 5 \
        "pdf" "PDF Belgesi" \
        "docx" "Microsoft Word" \
        "html" "HTML Sayfası" \
        "md" "Markdown" \
        "epub" "E-Kitap" 3>&1 1>&2 2>&3)

    if [[ $? -ne 0 ]]; then exit 0; fi

    # 3. Çıktı Yolu
    local default_name="$(get_filename_no_ext "$input_file").$out_fmt"
    local output_file
    output_file=$(whiptail --title "Çıktı Konumu" --inputbox "Dosya nereye kaydedilsin?" 10 70 "$DEFAULT_DIR/$default_name" 3>&1 1>&2 2>&3)

    if [[ $? -ne 0 ]]; then exit 0; fi

    # 4. Seçenekler
    local t_state="OFF"; [[ "$DEFAULT_TOC" == "TRUE" ]] && t_state="ON"
    local s_state="OFF"; [[ "$DEFAULT_STANDALONE" == "TRUE" ]] && s_state="ON"
    local n_state="OFF"; [[ "$DEFAULT_NUMSEC" == "TRUE" ]] && n_state="ON"

    local choices
    choices=$(whiptail --title "Ayarlar" --checklist "Pandoc Seçenekleri (Seçim için BOŞLUK tuşu)" 15 70 4 \
        "TOC" "İçindekiler Tablosu" $t_state \
        "STANDALONE" "Bağımsız Belge" $s_state \
        "NUMSEC" "Bölüm Numaralandırma" $n_state 3>&1 1>&2 2>&3)
    
    if [[ $? -ne 0 ]]; then exit 0; fi

    local toc="FALSE"; local standalone="FALSE"; local num_sec="FALSE"
    [[ $choices == *"TOC"* ]] && toc="TRUE"
    [[ $choices == *"STANDALONE"* ]] && standalone="TRUE"
    [[ $choices == *"NUMSEC"* ]] && num_sec="TRUE"

    # 5. Metadata
    local doc_title
    doc_title=$(whiptail --title "Metadata" --inputbox "Belge Başlığı (İsteğe bağlı):" 10 70 "" 3>&1 1>&2 2>&3)
    
    # Ayarları Kaydet
    local out_dir=$(dirname "$output_file")
    save_config "$out_dir" "$DEFAULT_AUTHOR" "$toc" "$num_sec" "$standalone"

    # Komutu Hazırla
    build_pandoc_cmd "$input_file" "$output_file" "$toc" "$standalone" "$num_sec" "" "$doc_title" "$DEFAULT_AUTHOR" ""

    # Çalıştırma (Progress Bar)
    {
        echo 10; sleep 0.5
        echo 50; run_pandoc; echo 100
    } | whiptail --gauge "Dönüştürülüyor..." 6 60 0

    # Sonuç
    if [[ -s "$LAST_RUN_ERR" ]]; then
        whiptail --textbox "$LAST_RUN_ERR" 12 70
    else
        if whiptail --title "Başarılı" --yesno "Dosya başarıyla oluşturuldu!\n\n$output_file\n\nDosyayı şimdi açmak ister misiniz?" 10 70; then
            nohup xdg-open "$output_file" >/dev/null 2>&1 & 
        fi
    fi
}
