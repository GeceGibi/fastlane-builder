# Fastlane Builder 🚀

Centralized, standalone, and portable Fastlane configuration for Flutter projects. Optimized for remote usage via `import_from_git`.

## Features
- **Standalone**: All helper methods are embedded within each file. No external dependencies.
- **Remote-First**: Designed to be imported directly from this repository.
- **Dynamic Root Detection**: Automatically identifies Flutter project root via `pubspec.yaml`.
- **Flavor Support**: Dynamic environment variable lookup based on `FLAVOR` (e.g., `PROD_IOS_BUNDLE_ID` vs `IOS_BUNDLE_ID`).
- **Metadata Automation**: Automatically ensures standard Fastlane metadata structure exists for all platforms.
- **Auto-Update**: Automatically checks for Fastlane and plugin updates on every run.

## 🚀 Usage

### Option 1: Git Submodule (Recommended)
This is the most robust method as it ensures all shared helpers and files are physically present.

1.  **Add Submodule:**
    Run this in your project root:
    ```bash
    git submodule add https://github.com/GeceGibi/fastlane-builder.git fastlane-builder
    ```

2.  **Initialize Submodule (For CI or New Clones):**
    Ensure this runs after cloning your repo:
    ```bash
    git submodule update --init --recursive
    ```

3.  **Bridge Configuration (No Symlinks):**
    Instead of symlinks (which can fail on some systems), create a "Bridge" `Fastfile` in your project that simply imports the submodule's Fastfile.

    **iOS (`ios/fastlane/Fastfile`):**
    ```ruby
    # Import the real Fastfile from submodule
    import "../../fastlane-builder/ios/Fastfile"
    ```

    **Android (`android/fastlane/Fastfile`):**
    ```ruby
    import "../../fastlane-builder/android/Fastfile"
    ```

    **Huawei (`android/fastlane/Fastfile` - if separate dir):**
    ```ruby
    import "../../fastlane-builder/huawei/Fastfile"
    ```

### Option 2: `import_from_git` (Not Recommended for this setup)
Since this repo uses shared helper files, `import_from_git` may fail to correctly resolve relative paths to `shared/helpers.rb`. Use the Submodule method above.

## ⚙️ CI/CD Configuration

When using submodules, you **must** configure your pipeline to checkout submodules recursively.

### Azure DevOps (`azure-pipelines.yml`)
```yaml
steps:
- checkout: self
  submodules: true  # Critical!
  persistCredentials: true
```

### GitHub Actions (`.github/workflows/deploy.yml`)
```yaml
steps:
  - uses: actions/checkout@v4
    with:
      submodules: recursive # Critical!
      fetch-depth: 0
```

## Migration Guide 🛠️

1. **Fastfile Config**: Add the `import_from_git` blocks as shown above.
2. **Optional Appfile**: You can delete local `Appfile`s as all params are now read from ENV variables.
3. **Environment Variables**: Define necessary ENV variables in your CI/CD pipeline or local `.env`.
4. **Verification**: Run `fastlane dev` to verify the remote configuration is fetched and working correctly.

## Environment Variables

The system automatically performs a prefix lookup based on the `FLAVOR` variable.

### Common
| Variable | Required | Description |
|----------|----------|-------------|
| Variable | Required | Description |
|----------|----------|-------------|
| `FLAVOR` | ❌ | App flavor (e.g., dev, prod) |
| `SUPPORTED_LOCALES` | ❌ | Comma separated locales (Default: `tr-TR`) |

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
| `ANDROID_METADATA_PATH` | ❌ | Custom metadata path (Default: `android/fastlane/metadata`) |

### Huawei
| Variable | Required | Description |
|----------|----------|-------------|
| `HUAWEI_APP_ID` | ✅ | Huawei App ID |
| `HUAWEI_CLIENT_ID` | ✅ | Huawei Client ID |
| `HUAWEI_CLIENT_SECRET` | ✅ | Huawei Client Secret |


## Metadata Structure 📂

The system automatically ensures the following structure exists and loads it during deploy:

### iOS
- Path: `ios/fastlane/metadata/<locale>/release_notes.txt`

### Android
- Path: `android/fastlane/metadata/android/<locale>/changelogs/default.txt`

### Huawei
- Path: `android/fastlane/metadata/huawei/<locale>/changelog.txt`

> **Automatic Creation:** Directories and default `changelog/release_notes` files are created automatically in `before_all`.

## Lanes

- `fastlane dev`: Deploy to Test/Beta tracks (TestFlight, Play Store Beta, Huawei AppGallery Draft).
- `fastlane prod`: Deploy to Production tracks.

## Update Strategy 🔄

1. **Shared Config**: Since we use `import_from_git`, your project always uses the latest logic from this repo automatically.
2. **Fastlane & Plugins**: `update_fastlane` is called in `before_all`, maintaining everything up-to-date automatically on every run.
