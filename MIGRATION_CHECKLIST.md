# Fastlane Builder Migration Checklist

To-do for each project:

## My Tasks

### 1. Submodule and Symlink Setup
- [ ] `git submodule add https://github.com/GeceGibi/fastlane-builder.git`
- [ ] Run `./fastlane-builder/setup.sh` (This script automatically detects existing platforms in your project and only creates links for them)

### 2. Find Hardcoded Values
- [ ] Inspect existing Fastfiles in `ios/` and `android/`.
- [ ] Note Bundle ID, package name, and credential paths

### 3. Pipeline Setup
- [ ] Add `submodules: true` to the pipeline file
- [ ] Add ENV variables to the pipeline:
  - **iOS**: `IOS_BUNDLE_ID`, `IOS_AUTH_KEY_ID`, `IOS_ISSUER_ID`, `IOS_AUTH_KEY_PATH`
  - **Android**: `ANDROID_PACKAGE_NAME`, `ANDROID_SERVICE_ACCOUNT_PATH`
  - **Huawei**: `HUAWEI_APP_ID`, `HUAWEI_CLIENT_ID`, `HUAWEI_CLIENT_SECRET`
  - **Common**: `FLAVOR`

### 4. Local Setup (If CI/CD Does Not Exist)
- [ ] Create `.env` file (ensure it's in gitignore)
- [ ] Add required values to `.env`

### 5. Verification
- [ ] Verify build/deploy scripts work for each active platform
