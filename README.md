# Fastlane Builder

Shared Fastlane configuration for multiple Flutter mobile projects.

## Setup

### 1. Add as Git Submodule (Recommended)

```bash
# In your Flutter project root
git submodule add https://github.com/YOUR_ORG/fastlane-builder.git

# Link fastlane directories
ln -s ../fastlane-builder/ios/Fastfile ios/fastlane/Fastfile
ln -s ../fastlane-builder/ios/Appfile ios/fastlane/Appfile
ln -s ../fastlane-builder/android/Fastfile android/fastlane/Fastfile
ln -s ../fastlane-builder/android/Appfile android/fastlane/Appfile
```

### 2. Copy .env.template

```bash
cp fastlane-builder/.env.template .env
# Edit .env with your project-specific values
```

## Usage

### iOS

```bash
cd ios
bundle install
bundle exec fastlane ios dev project_root:$(pwd)/..
bundle exec fastlane ios prod project_root:$(pwd)/..
```

### Android

```bash
cd android
bundle install
bundle exec fastlane android dev project_root:$(pwd)/..
bundle exec fastlane android prod project_root:$(pwd)/..
```

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `FLAVOR` | App flavor/brand identifier | `secil` |
| `PROJECT_ROOT` | Absolute path to Flutter project | `/Users/dev/myapp` |
| `TEMP_ROOT` | Path to credentials folder | `/tmp/credentials` |
| `AUTH_KEY_ID` | App Store Connect API Key ID | `ABC123` |
| `ISSUER_ID` | App Store Connect Issuer ID | `xyz-456` |

## CI/CD Integration

### GitHub Actions Example

```yaml
- name: Clone fastlane-builder
  run: git submodule update --init --recursive

- name: iOS Deploy
  run: |
    cd ios
    bundle install
    bundle exec fastlane ios prod project_root:${{ github.workspace }}
  env:
    FLAVOR: ${{ secrets.APP_FLAVOR }}
    AUTH_KEY_ID: ${{ secrets.AUTH_KEY_ID }}
    ISSUER_ID: ${{ secrets.ISSUER_ID }}
```

## Updating

```bash
git submodule update --remote fastlane-builder
git add fastlane-builder
git commit -m "Update fastlane-builder"
```
