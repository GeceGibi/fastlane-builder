# Fastlane Builder Migration Checklist

Her proje için yapılacaklar:

## Benim Görevlerim

### 1. Submodule ve Symlink Kurulumu
- [ ] `git submodule add https://github.com/GeceGibi/fastlane-builder.git`
- [ ] Eski Fastfile/Appfile sil, symlink oluştur

### 2. Hardcoded Değerleri Bul
- [ ] Mevcut `ios/fastlane/Fastfile` ve `android/fastlane/Fastfile` incele
- [ ] Bundle ID, package name, credential path'leri not al

### 3. CI/CD Varsa
- [ ] Pipeline dosyasına `submodules: true` ekle
- [ ] ENV değişkenlerini pipeline'a ekle:
  - `IOS_BUNDLE_ID`
  - `IOS_AUTH_KEY_ID`, `IOS_ISSUER_ID`, `IOS_AUTH_KEY_PATH`
  - `ANDROID_PACKAGE_NAME`, `ANDROID_SERVICE_ACCOUNT_PATH`
  - `FLAVOR` (varsa)

### 4. CI/CD Yoksa
- [ ] `.env` dosyası oluştur (gitignore'da olmalı)
- [ ] Gerekli değerleri `.env`'e yaz

### 5. Pipeline Kontrolü
- [ ] Build script'lerinin doğru çalıştığını kontrol et

---

## Projeler

### com.secil.mobile ✅
- [x] Submodule + Symlink
- [x] Pipeline güncellendi  
- [x] Test edildi (kullanıcı tarafından)

### [Proje 2]
- [ ] Submodule + Symlink
- [ ] Hardcoded değerler
- [ ] CI/CD güncelleme
- [ ] Kontrol

### [Proje 3]
- [ ] Submodule + Symlink
- [ ] Hardcoded değerler
- [ ] CI/CD güncelleme
- [ ] Kontrol
