# Fastlane Builder 🚀

Centralized, standalone, and portable Fastlane configuration for Flutter projects. Optimized for remote usage via `import_from_git`.

## Features
- **Standalone**: All helper methods are embedded within each file. No external dependencies.
- **Remote-First**: Designed to be imported directly from this repository.
- **Dynamic Root Detection**: Automatically identifies Flutter project root via `pubspec.yaml`.
- **Flavor Support**: Dynamic environment variable lookup based on `FLAVOR` (e.g., `PROD_IOS_BUNDLE_ID` vs `IOS_BUNDLE_ID`).

## Setup (Remote Import)

You don't need to add this repo as a submodule or create symlinks. Simply add the following blocks to your local `Fastfile`s.

### 1. iOS Setup
Add to `ios/fastlane/Fastfile`:
```ruby
import_from_git(
  url: 'https://github.com/GeceGibi/fastlane-builder.git',
  path: 'ios/Fastfile'
)
```

### 2. Android Setup
Add to `android/fastlane/Fastfile`:
```ruby
import_from_git(
  url: 'https://github.com/GeceGibi/fastlane-builder.git',
  path: 'android/Fastfile'
)
```

### 3. Huawei Setup
Add to `huawei/fastlane/Fastfile`:
```ruby
import_from_git(
  url: 'https://github.com/GeceGibi/fastlane-builder.git',
  path: 'huawei/Fastfile'
)
```

> **Note:** Since `Appfile` configurations are project-specific and cannot be remotely imported by Fastlane, you should keep a local copy of `Appfile` in your project folders.

## Migration Guide 🛠️

1. **Fastfile Config**: Add the `import_from_git` blocks as shown above.
2. **Appfile Check**: Ensure your local `Appfile`s have the correct package names and credentials.
3. **Environment Variables**: Define necessary ENV variables in your CI/CD pipeline or local `.env`.
4. **Verification**: Run `fastlane dev` to verify the remote configuration is fetched and working correctly.

## Environment Variables

The system automatically performs a prefix lookup based on the `FLAVOR` variable.

### Common
| Variable | Required | Description |
|----------|----------|-------------|
| `FLAVOR` | ❌ | App flavor (e.g., dev, prod) |

### iOS
| Variable | Required | Description |
|----------|----------|-------------|
| `IOS_BUNDLE_ID` | ✅ | App Bundle Identifier |
| `IOS_AUTH_KEY_ID` | ✅ | ASC API Key ID |
| `IOS_ISSUER_ID` | ✅ | ASC Issuer ID |
| `IOS_AUTH_KEY_CONTENT` | ❌ | Raw .p8 key content (Preferred for CI) |

### Android
| Variable | Required | Description |
|----------|----------|-------------|
| `ANDROID_PACKAGE_NAME` | ✅ | App Package Name |
| `ANDROID_SERVICE_ACCOUNT_JSON` | ✅ | Raw Service Account JSON content |

## .env Template

Copy this into your project's `.env` file:

```env
# Common
FLAVOR=

# iOS
IOS_BUNDLE_ID=
IOS_AUTH_KEY_ID=
IOS_ISSUER_ID=
IOS_AUTH_KEY_CONTENT=

# Android
ANDROID_PACKAGE_NAME=
ANDROID_SERVICE_ACCOUNT_JSON=

# Huawei
HUAWEI_APP_ID=
HUAWEI_CLIENT_ID=
HUAWEI_CLIENT_SECRET=
```

## Lanes

- `fastlane dev`: Deploy to Test/Beta tracks (TestFlight, Play Store Beta).
- `fastlane prod`: Deploy to Production tracks.
