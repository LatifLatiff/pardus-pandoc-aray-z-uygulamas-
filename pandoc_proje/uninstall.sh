#!/bin/bash

# Dosya Yolları
DESKTOP_FILE="$HOME/.local/share/applications/pardus-pandoc.desktop"
CONFIG_DIR="$HOME/.config/pandoc-frontend"
LOG_DIR="$HOME/.cache/pandoc-frontend"

echo "Pardus Pandoc Arayüzü kaldırılıyor..."

# 1. Menü kısayolunu sil
if [[ -f "$DESKTOP_FILE" ]]; then
    rm "$DESKTOP_FILE"
    echo "✅ Menü kısayolu kaldırıldı."
else
    echo "ℹ️ Menü kısayolu zaten yok."
fi

# 2. Ayar dosyalarını sil (Kullanıcıya sorarak)
read -p "Ayar dosyaları ve loglar da silinsin mi? (e/h): " choice
if [[ "$choice" == "e" || "$choice" == "E" ]]; then
    rm -rf "$CONFIG_DIR"
    rm -rf "$LOG_DIR"
    echo "✅ Ayarlar ve loglar temizlendi."
else
    echo "ℹ️ Ayarlar saklandı."
fi

echo "🗑️ Kaldırma işlemi tamamlandı."
