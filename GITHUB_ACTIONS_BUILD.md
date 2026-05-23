# GitHub Actions ile tek tık Windows EXE üretme

Bu paket, projeyi GitHub üzerinde otomatik derleyip indirilebilir `.exe` paketi oluşturur.

## 1. GitHub'a yükle

1. GitHub hesabına gir.
2. New repository oluştur.
3. Bu klasördeki tüm dosyaları repoya yükle.

## 2. Tek tık build çalıştır

1. Repoda **Actions** sekmesine gir.
2. Soldan **Build Windows EXE** seç.
3. **Run workflow** butonuna bas.
4. Yeşil tik çıkana kadar bekle.

## 3. EXE'yi indir

1. Tamamlanan workflow run'ına tıkla.
2. Sayfanın altında **Artifacts** bölümünü bul.
3. **OpcodeFinder-Windows-x64** dosyasını indir.
4. ZIP'i aç.
5. `OpcodeFinder.exe` dosyasını çalıştır.

## Not

GitHub ilk yüklemede Actions'ı görünür hale getirmek için bazen birkaç saniye ister. Actions sekmesinde workflow görünmezse sayfayı yenile.
