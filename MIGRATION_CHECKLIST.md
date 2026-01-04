# Fastlane Builder Geçiş Listesi 🚀

## 1. Fastfile Konfigürasyonu
- [ ] Projenizdeki `ios/fastlane/Fastfile` ve `android/fastlane/Fastfile` dosyalarının en başına `import_from_git` bloğunu ekleyin.

## 2. Appfile Kontrolü
- [ ] Projenizin içindeki `Appfile` dosyalarının package_name/bundle_id değerlerini kontrol edin (veya bu repo üzerindekileri örnek alarak güncelleyin).

## 3. Ortam Değişkenleri (Pipeline)
- [ ] Pipeline üzerinde gerekli ENV değişkenlerini tanımlayın:
  - **Dinamik Prefix**: `DEV_`, `PROD_` gibi prefixleri `FLAVOR` değişkenine göre kullanabilirsiniz.
  - **iOS**: `IOS_BUNDLE_ID`, `IOS_AUTH_KEY_ID`, `IOS_ISSUER_ID`, `IOS_AUTH_KEY_CONTENT`
  - **Android**: `ANDROID_PACKAGE_NAME`, `ANDROID_SERVICE_ACCOUNT_JSON`

## 4. Test
- [ ] `fastlane dev` komutu ile remote konfigürasyonun başarıyla çekildiğini ve çalıştığını doğrulayın.

## 4. Yerel Test
- [ ] `.env` dosyası oluştur (gitignore'da olduğundan emin ol).
- [ ] `fastlane dev` veya `fastlane prod` ile testi tamamla.
