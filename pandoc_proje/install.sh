#!/bin/bash

# Uygulama Yolu (Mevcut klasör)
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICON_PATH="/usr/share/icons/Adwaita/48x48/mimetypes/x-office-document.png" # Sistem ikonu
DESKTOP_FILE="$HOME/.local/share/applications/pardus-pandoc.desktop"

echo "=========================================="
echo "   Pardus Pandoc Arayüzü Kurulumu"
echo "=========================================="

# 1. BAĞIMLILIK KONTROLÜ VE YÜKLEME
# PDF hatasını önlemek için texlive paketlerini de ekliyoruz.
echo "📦 Gerekli paketler kontrol ediliyor..."
echo "Lütfen sudo şifrenizi giriniz (Paket yüklemesi için gerekli):"

sudo apt update
sudo apt install pandoc yad whiptail texlive-latex-recommended texlive-fonts-recommended -y

if [[ $? -ne 0 ]]; then
    echo "❌ Paket yükleme hatası! İnternet bağlantınızı kontrol edin."
    exit 1
fi

echo "✅ Tüm bağımlılıklar hazır."

# 2. MASAÜSTÜ KISAYOLU OLUŞTURMA
echo "🚀 Uygulama kısayolu oluşturuluyor..."

mkdir -p "$HOME/.local/share/applications"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Pardus Belge Dönüştürücü
Comment=Pandoc Frontend GUI
Exec=$APP_DIR/src/app.sh --gui
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Utility;Office;
EOF

# 3. ÇALIŞTIRMA İZİNLERİ
chmod +x "$APP_DIR/src/app.sh"
chmod +x "$DESKTOP_FILE"

echo "=========================================="
echo "✅ KURULUM BAŞARIYLA TAMAMLANDI!"
echo "📂 Uygulamalar menüsünde 'Pardus Belge Dönüştürücü' olarak aratabilirsiniz."
echo "=========================================="
