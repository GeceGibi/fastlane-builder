# Fastlane Builder 🚀

Flutter projeleriniz için merkezi ve taşınabilir Fastlane konfigürasyonu. Tüm dosyalar **standalone** yapıdadır ve doğrudan uzak repo üzerinden kullanılmak üzere optimize edilmiştir.

## Kurulum (Remote Import)

Bu repoyu projelerinize submodule olarak eklemenize veya symlink oluşturmanıza gerek yoktur. Projenizdeki `Fastfile` dosyalarına ilgili bloğu eklemeniz yeterlidir.

### 1. iOS Kurulum
`ios/fastlane/Fastfile` dosyanızın en başına ekleyin:

```ruby
import_from_git(
  url: 'https://github.com/GeceGibi/fastlane-builder.git',
  path: 'ios/Fastfile'
)
```

### 2. Android Kurulum
`android/fastlane/Fastfile` dosyanızın en başına ekleyin:

```ruby
import_from_git(
  url: 'https://github.com/GeceGibi/fastlane-builder.git',
  path: 'android/Fastfile'
)
```

### 3. Huawei Kurulum
`huawei/fastlane/Fastfile` dosyanızın en başına ekleyin:

```ruby
import_from_git(
  url: 'https://github.com/GeceGibi/fastlane-builder.git',
  path: 'huawei/Fastfile'
)
```

> **Not:** `Appfile` merkezi olarak yönetilemediği için projenizin içinde (ios/android/huawei klasörlerinde) ilgili `Appfile` dosyasının bir kopyası bulunmalıdır.

## Değişkenler (Environment Variables)

Sistem, `FLAVOR` değişkenine göre otomatik prefix lookup yapar (örn: `PROD_IOS_BUNDLE_ID`).

### Ortak Ayarlar
| Değişken | Açıklama |
|----------|----------|
| `FLAVOR` | Uygulama flavor'ı (örn: dev, prod) |

### iOS
| Değişken | Zorunlu | Açıklama |
|----------|----------|-------------|
| `IOS_BUNDLE_ID` | ✅ | Uygulama Bundle ID |
| `IOS_AUTH_KEY_ID` | ✅ | ASC API Key ID |
| `IOS_ISSUER_ID` | ✅ | ASC Issuer ID |
| `IOS_AUTH_KEY_CONTENT`| ❌ | .p8 dosya içeriği |

### Android
| Değişken | Zorunlu | Açıklama |
|----------|----------|-------------|
| `ANDROID_PACKAGE_NAME` | ✅ | Uygulama Paket Adı |
| `ANDROID_SERVICE_ACCOUNT_JSON`| ✅ | Service Account JSON içeriği |

## Lanes

- `fastlane dev`: Test/Beta track yüklemesi.
- `fastlane prod`: Production track yüklemesi.

