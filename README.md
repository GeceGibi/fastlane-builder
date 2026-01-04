# Fastlane Builder

Shared Fastlane configuration for multiple Flutter mobile projects.

## Setup

### 1. Add as Git Submodule

```bash
# In your Flutter project root
git submodule add https://github.com/GeceGibi/fastlane-builder.git

# Create symlinks
ln -s ../../fastlane-builder/ios/Fastfile ios/fastlane/Fastfile
ln -s ../../fastlane-builder/ios/Appfile ios/fastlane/Appfile
ln -s ../../fastlane-builder/android/Fastfile android/fastlane/Fastfile
ln -s ../../fastlane-builder/android/Appfile android/fastlane/Appfile
```

### 2. Submodule Checkout in CI/CD

```yaml
# Azure DevOps
- checkout: self
  submodules: true

# GitHub Actions
- uses: actions/checkout@v4
  with:
    submodules: true
```

## Usage

```bash
# iOS
cd ios && fastlane dev --verbose
cd ios && fastlane prod --verbose

# Android
cd android && fastlane dev --verbose
cd android && fastlane prod --verbose
```

## Environment Variables

### Flavor Prefix Support

All ENV variables support flavor prefixes:
- `{FLAVOR}_IOS_*` is checked first; if not found, `IOS_*` is used.

### iOS Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `IOS_BUNDLE_ID` | ✅ | App bundle identifier |
| `IOS_AUTH_KEY_ID` | ✅ | App Store Connect API Key ID |
| `IOS_ISSUER_ID` | ✅ | App Store Connect Issuer ID |
| `IOS_AUTH_KEY_PATH` | ❌ | Path to .p8 auth key file (if content not provided) |
| `IOS_AUTH_KEY_CONTENT` | ❌ | Raw content of .p8 auth key file |
| `IOS_METADATA_PATH` | ❌ | Metadata folder path (default: `metadata`) |
| `IOS_GOOGLE_SERVICE_PLIST_PATH` | ❌ | GoogleService-Info.plist for Crashlytics |
| `IOS_USE_TRANSPORTER` | ❌ | Enable Transporter (default: `true`) |
| `IOS_TRANSPORTER_PATH` | ❌ | Transporter path (default: `/Applications/Transporter.app/Contents/itms`) |

### Huawei Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `HUAWEI_CLIENT_ID` | ✅ | Client ID from Huawei Connect |
| `HUAWEI_CLIENT_SECRET` | ✅ | Client Secret from Huawei Connect |
| `HUAWEI_APP_ID` | ✅ | App ID from Huawei Connect |

### Android Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `ANDROID_PACKAGE_NAME` | ✅ | App package name |
| `ANDROID_SERVICE_ACCOUNT_PATH` | ✅ | Path to service_account.json |
| `ANDROID_METADATA_PATH` | ❌ | Metadata folder path (default: `metadata`) |

### Common Variables

| Variable | Description |
|----------|-------------|
| `FLAVOR` | App flavor (enables prefix lookup) |

## Lanes

### Mobile (iOS/Android/Huawei)
- `dev` → Upload to Test/Beta track
- `prod` → Upload to Production track

## Updating Submodule

```bash
git submodule update --remote fastlane-builder
git add fastlane-builder
git commit -m "chore: update fastlane-builder"
```
