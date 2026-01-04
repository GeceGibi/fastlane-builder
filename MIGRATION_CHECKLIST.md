# Fastlane Builder Migration Checklist

To-do for each project:

## My Tasks

### 1. Submodule and Symlink Setup
- [ ] `git submodule add https://github.com/GeceGibi/fastlane-builder.git`
- [ ] Delete old Fastfile/Appfile, create symlinks

### 2. Find Hardcoded Values
- [ ] Inspect existing `ios/fastlane/Fastfile` and `android/fastlane/Fastfile`
- [ ] Note Bundle ID, package name, and credential paths

### 3. If CI/CD Exists
- [ ] Add `submodules: true` to the pipeline file
- [ ] Add ENV variables to the pipeline:
  - `IOS_BUNDLE_ID`
  - `IOS_AUTH_KEY_ID`, `IOS_ISSUER_ID`, `IOS_AUTH_KEY_PATH`
  - `ANDROID_PACKAGE_NAME`, `ANDROID_SERVICE_ACCOUNT_PATH`
  - `FLAVOR` (if applicable)

### 4. If CI/CD Does Not Exist
- [ ] Create `.env` file (ensure it's in gitignore)
- [ ] Add required values to `.env`

### 5. Pipeline Verification
- [ ] Verify build scripts work correctly