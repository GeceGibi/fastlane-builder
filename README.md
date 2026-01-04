# Fastlane Builder

Shared Fastlane configuration for multiple Flutter mobile projects. Optimized for CI/CD with flavor support.

## Setup

### 1. Add as Git Submodule and Link

Run this from your Flutter project root:

```bash
# Add the submodule
git submodule add https://github.com/GeceGibi/fastlane-builder.git

# Run the setup script to automatically link active platforms
./fastlane-builder/setup.sh
```

### 2. CI/CD Configuration

```yaml
# Azure DevOps
- checkout: self
  submodules: true

# GitHub Actions
- uses: actions/checkout@v4
  with:
    submodules: true
```

## Environment Variables

### Flavor Prefix Support

Variables support automatic flavor lookup:
- If `FLAVOR=prod`, it checks `PROD_IOS_BUNDLE_ID` first.
- Fallback is `IOS_BUNDLE_ID`.

### iOS Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `IOS_BUNDLE_ID` | ✅ | App bundle identifier |
| `IOS_AUTH_KEY_ID` | ✅ | App Store Connect API Key ID |
| `IOS_ISSUER_ID` | ✅ | App Store Connect Issuer ID |
| `IOS_AUTH_KEY_CONTENT` | ❌ | Raw content of .p8 auth key file (Preferred for CI) |
| `IOS_AUTH_KEY_PATH` | ❌ | Path to .p8 auth key file (Fallback) |
| `IOS_METADATA_PATH` | ❌ | Metadata path. Auto-detects `{path}/{platform}` subfolders. |
| `IOS_GOOGLE_SERVICE_PLIST_PATH`| ❌ | GoogleService-Info.plist for Crashlytics dSYM upload |

### Android Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `ANDROID_PACKAGE_NAME` | ✅ | App package name |
| `ANDROID_SERVICE_ACCOUNT_JSON` | ❌ | Raw Service Account JSON content (Preferred for CI) |
| `ANDROID_SERVICE_ACCOUNT_PATH` | ❌ | Path to service_account.json (Fallback) |
| `ANDROID_METADATA_PATH` | ❌ | Metadata path. Auto-detects `{path}/{platform}` subfolders. |

### Huawei Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `HUAWEI_CLIENT_ID` | ✅ | Client ID from Huawei Connect |
| `HUAWEI_CLIENT_SECRET` | ✅ | Client Secret from Huawei Connect |
| `HUAWEI_APP_ID` | ✅ | App ID from Huawei Connect |

## Lanes

- `dev` → Upload to Test/Beta track (TestFlight / Play Store Beta / AppGallery Draft)
- `prod` → Upload to Production track

## Updating

```bash
git submodule update --remote fastlane-builder
git add fastlane-builder
git commit -m "chore: update fastlane-builder"
```
