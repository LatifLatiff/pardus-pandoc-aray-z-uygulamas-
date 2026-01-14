# 📄 Pardus Pandoc Arayüzü (Pandoc Frontend)

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![OS](https://img.shields.io/badge/OS-Pardus%20%2F%20Linux-1793D1?style=flat&logo=linux&logoColor=white)
![License](https://img.shields.io/badge/License-GPLv3-blue.svg)

**Linux Scriptleri ve Araçları** dersi dönem projesi kapsamında geliştirilmiş; karmaşık `pandoc` komutlarını kullanıcı dostu bir arayüzle (GUI & TUI) yönetmeyi sağlayan, **Pardus** uyumlu profesyonel belge dönüştürme aracıdır.

---

## 📋 İçindekiler
- [Proje Hakkında](#-proje-hakkında)
- [Özellikler](#-özellikler)
- [Gereksinimler](#-gereksinimler)
- [Kurulum](#-kurulum)
- [Kullanım](#-kullanım)
- [Proje Mimarisi](#-proje-mimarisi)
- [Ekran Görüntüleri](#-ekran-görüntüleri)
- [Tanıtım Videosu](#-tanıtım-videosu)
- [Geliştirici](#-geliştirici)

---

## 🚀 Proje Hakkında
Bu projenin temel amacı, Linux terminalinde güçlü ancak karmaşık parametrelere sahip olan **Pandoc** aracı için modern ve kullanımı kolay bir ön yüz (Frontend) oluşturmaktır.

Kullanıcılar terminal komutlarıyla uğraşmadan **Markdown, DOCX, HTML, EPUB ve PDF** formatları arasında güvenli ve hızlı bir şekilde dönüşüm yapabilirler. Uygulama, kullanıcının tercihine göre Grafik Arayüz (GUI) veya Terminal Arayüzü (TUI) ile çalışabilir.

---

## ✨ Özellikler

* **Çift Arayüz Desteği:**
    * 🖥️ **GUI (YAD):** Form tabanlı, ikonlu ve modern grafik arayüz.
    * ⌨️ **TUI (Whiptail):** Klavye ile kontrol edilebilen, hafif terminal arayüzü.
* **Geniş Format Desteği:** `.md`, `.docx`, `.html`, `.tex`, `.rst` girdilerini; PDF, Word, HTML, Markdown ve EPUB formatlarına dönüştürür.
* **Akıllı Ayarlar (Persistence):** Uygulama kapatılsa bile son kullanılan klasörü, yazar adını ve tercihleri hatırlar.
* **Pardus Entegrasyonu:** Tek tıkla uygulama menüsüne eklenir, masaüstü kısayolu oluşturur ve sistem ikonlarını kullanır.
* **Gelişmiş Seçenekler:** İçindekiler tablosu (TOC), bölüm numaralandırma, kod vurgulama (syntax highlighting) ve CSS desteği.
* **Güvenli Çalışma:** Modüler kod yapısı, hata yakalama (trap), loglama sistemi ve otomatik temizlik.

---

## 📦 Gereksinimler

Projenin çalışması için aşağıdaki paketlerin sistemde yüklü olması gerekmektedir (Kurulum scripti bunları otomatik kontrol eder):

* `bash` (Kabuk)
* `pandoc` (Dönüştürme motoru)
* `yad` (Grafik arayüz için)
* `whiptail` (Terminal arayüz için)
* `texlive-latex-recommended` (PDF oluşturmak için)

---

## 🛠 Kurulum

Projeyi bilgisayarınıza indirdikten sonra, **tek komutla** tüm bağımlılıkları yükleyip kurulumu tamamlayabilirsiniz.

1.  **Terminali açın ve proje dizinine girin:**
    ```bash
    cd pandoc_proje
    ```

2.  **Kurulum scriptini çalıştırın:**
    ```bash
    chmod +x install.sh
    ./install.sh
    ```
    *(Bu işlem gerekli paketleri yükleyecek, masaüstü kısayolunu oluşturacak ve uygulamayı Pardus menüsüne ekleyecektir.)*

3.  **Kaldırma (Uninstall):**
    Uygulamayı sistemden tamamen silmek için:
    ```bash
    ./uninstall.sh
    ```

---

## 🎮 Kullanım

Uygulamayı başlatmanın üç yolu vardır:

### 1. Uygulama Menüsünden
Pardus menüsünde **"Pardus Belge Dönüştürücü"** olarak aratıp tıklayın.

### 2. Terminalden (Otomatik Mod)
Sisteminizde grafik arayüz varsa GUI, yoksa TUI açılır:
```bash
./src/app.sh

### 3. Mod Zorlama

Belirli bir arayüzü kullanmak isterseniz:
Bash

./src/app.sh --gui   # Grafik Arayüzü Zorla
./src/app.sh --tui   # Terminal Arayüzü Zorla
./src/app.sh --help  # Yardım Menüsü

###  Proje Mimarisi

Proje, "Modüler Programlama" prensiplerine uygun olarak parçalanmış dosya yapısına sahiptir:
Plaintext

pandoc_proje/
├── install.sh             # Otomatik kurulum scripti
├── uninstall.sh           # Kaldırma ve temizleme scripti
├── README.md              # Proje dökümantasyonu
├── logo.png               # Uygulama logosu
└── src/
    ├── app.sh             # Ana giriş noktası (Main)
    └── lib/               # Kütüphane dosyaları
        ├── common.sh      # Ortak değişkenler ve yardımcılar
        ├── config.sh      # Ayar kaydetme/okuma (Persistence)
        ├── core.sh        # Pandoc komut inşası
        ├── deps.sh        # Bağımlılık kontrolü
        ├── gui.sh         # YAD arayüz kodları
        ├── tui.sh         # Whiptail arayüz kodları
        ├── logging.sh     # Loglama sistemi
        ├── presets.sh     # Format tanımları
        └── validators.sh  # Dosya doğrulama fonksiyonları

### Ekran Görüntüleri
## Grafik Arayüz (GUI)

![GUI Görünümü]([pandoc_proje/docs/gui.png](https://github.com/LatifLatiff/pardus-pandoc-aray-z-uygulamas-/blob/main/pandoc_proje/docs/qui.png))
## Terminal Arayüz (TUI)

![TUI Görünümü](pandoc_proje/docs/tui.png)
### Tanıtım Videosu

Projenin kurulumunu, kullanımını ve özelliklerini detaylıca anlatan tanıtım videosuna aşağıdaki linkten ulaşabilirsiniz:

▶️ [YOUTUBE VİDEO LİNKİNİZİ BURAYA YAPIŞTIRIN]
### Geliştirici

    Ad Soyad: LATIF LATIF

    Bölüm: Bilgisayar Mühendisliği

    Ders: Linux Scriptleri ve Araçları

© 2026 - Bu proje GPLv3 lisansı ile açık kaynak olarak dağıtılmaktadır.
