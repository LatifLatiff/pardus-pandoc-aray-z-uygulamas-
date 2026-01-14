#!/bin/bash

# ==============================================================================
# Grafik Arayüz (YAD) 
# ==============================================================================

start_gui() {
    local output_formats=$(get_output_formats_yad)
    
    # 1. FORM EKRANI (Görselleştirildi)
    # --image: Sol tarafa Pardus sistem ikonu ekler.
    # --text: HTML etiketleri ile başlığı büyütüp renklendirdik.
    # Alan adlarına emojiler eklendi.
    # Butonlara GTK ikonları (!gtk-cancel, !gtk-ok) eklendi.
    
    local form_output
    form_output=$(yad --title="Pardus Pandoc Arayüzü" \
        --window-icon="applications-office" \
        --image="system-software-install" \
        --image-on-top \
        --text="<span size='x-large' weight='bold' color='#2c3e50'>Belge Dönüştürme Sihirbazı</span>\n<span color='#7f8c8d'>Lütfen dönüştürme ayarlarını aşağıdan seçiniz.</span>" \
        --width=750 --height=600 \
        --center \
        --form \
        --separator="|" \
        --scroll \
        --field="<b>📁 Girdi Dosyası</b>:FL" "" \
        --field="📂 Çıktı Klasörü:DIR" "$DEFAULT_DIR" \
        --field="📝 Çıktı Dosya Adı:TXT" "output" \
        --field="⚙️ Çıktı Formatı:CB" "$output_formats" \
        --field="📑 İçindekiler Tablosu (TOC):CHK" "$DEFAULT_TOC" \
        --field="📄 Bağımsız Belge (Standalone):CHK" "$DEFAULT_STANDALONE" \
        --field="🔢 Bölümleri Numarala:CHK" "$DEFAULT_NUMSEC" \
        --field="🎨 Kod Vurgulama Stili:CB" "pygments!tango!espresso!zenburn!kate!monochrome!breezedark!haddock" \
        --field="🏷️ Belge Başlığı:TXT" "" \
        --field="👤 Yazar:TXT" "$DEFAULT_AUTHOR" \
        --field="✨ CSS Dosyası (Opsiyonel):FL" "" \
        --button="İptal!gtk-cancel:1" \
        --button="Dönüştürmeyi Başlat!gtk-ok:0")

    if [[ $? -ne 0 ]]; then exit 0; fi

    IFS="|" read -r input_file out_dir out_name out_fmt toc standalone num_sec highlight title author css_file <<< "$form_output"

    if ! validate_input_file "$input_file"; then
        yad --error --title="Hata" --text="Geçersiz girdi dosyası seçtiniz!" --image="dialog-error"
        start_gui
        return
    fi

    # Ayarları Kaydet
    save_config "$out_dir" "$author" "$toc" "$num_sec" "$standalone"

    local full_output="${out_dir}/${out_name}.${out_fmt}"
    
    # Komutu Hazırla
    build_pandoc_cmd "$input_file" "$full_output" "$toc" "$standalone" "$num_sec" "$highlight" "$title" "$author" "$css_file"
    
    # 2. İLERLEME ÇUBUĞU (Hata Korumalı)
    (
        echo "10"; echo "# 🚀 İşlem başlatılıyor..."; sleep 0.5
        echo "50"; echo "# ⚙️ Pandoc dönüştürüyor..."; 
        
        if run_pandoc; then
            echo "100"; echo "# ✅ İşlem Tamamlandı!"
        else
            echo "100"; echo "# ❌ HATA OLUŞTU!"; touch "$TEMP_DIR/gui_error"
        fi
        sleep 0.5
    ) | yad --progress --title="İşleniyor" --percentage=0 --auto-close --no-escape --image="system-run" --width=400 || true

    # 3. SONUÇ EKRANI
    if [[ -f "$TEMP_DIR/gui_error" ]]; then
        rm -f "$TEMP_DIR/gui_error"
        local err_msg="Bilinmeyen hata"
        [[ -f "$LAST_RUN_ERR" ]] && err_msg=$(cat "$LAST_RUN_ERR")
        
        yad --error --title="Hata" \
            --text="<span weight='bold' size='large'>Dönüştürme Başarısız Oldu!</span>\n\n$err_msg" \
            --width=500 --image="dialog-error"
    else
        # Başarılı - Sadece 'Kapat' ve 'Dosyayı Aç' butonları (Klasör açma kaldırıldı)
        yad --title="İşlem Başarılı" \
            --image="emblem-default" \
            --text="<span size='x-large' weight='bold' color='#27ae60'>🎉 Dönüştürme Tamamlandı!</span>\n\nDosyanız başarıyla oluşturuldu:\n<b>$full_output</b>" \
            --width=600 \
            --center \
            --button="Kapat!gtk-close:1" \
            --button="Dosyayı Aç!gtk-open:0"
        
        local action=$?
        
        if [[ $action -eq 0 ]]; then
            # Dosyayı varsayılan programla aç (Nohup ile güvenli mod)
            nohup xdg-open "$full_output" >/dev/null 2>&1 & 
        fi
        
        exit 0
    fi
}
