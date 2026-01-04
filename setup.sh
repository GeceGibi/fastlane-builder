#!/bin/bash
# Sets up symbolic links for Fastlane configuration files in a Flutter project.
# Only configures platforms that exist in the project root.
set -e

echo "🚀 Fastlane Builder Setup"
echo "========================="

# Ensure script is run from Flutter project root
if [ ! -f "pubspec.yaml" ]; then
  echo "❌ pubspec.yaml not found. Run this script from Flutter project root."
  exit 1
fi

# Initialize or update the fastlane-builder submodule
if [ -d "fastlane-builder" ]; then
  echo "⚠️  fastlane-builder already exists. Updating..."
  git submodule update --remote fastlane-builder
else
  echo "📦 Adding fastlane-builder submodule..."
  git submodule add https://github.com/GeceGibi/fastlane-builder.git
fi

# Creates symlinks for Fastfile and Appfile if the target directory exists
setup_platform() {
  local name=$1
  local target_dir=$2
  local source_dir=$3
  
  if [ -d "$target_dir" ]; then
    echo "📁 Setting up $name fastlane..."
    mkdir -p "$target_dir/fastlane"
    rm -f "$target_dir/fastlane/Fastfile" "$target_dir/fastlane/Appfile"
    ln -s "../../fastlane-builder/$source_dir/Fastfile" "$target_dir/fastlane/Fastfile"
    ln -s "../../fastlane-builder/$source_dir/Appfile" "$target_dir/fastlane/Appfile"
  else
    echo "⏭️  Skipping $name (directory $target_dir not found)"
  fi
}

# Standard platforms (iOS and Android)
setup_platform "iOS" "ios" "ios"
setup_platform "Android" "android" "android"

# Huawei platform (uses shared android/ directory logic or dedicated huawei/ folder)
if [ -d "android" ] || [ -d "huawei" ]; then
    echo "📁 Setting up Huawei fastlane..."
    mkdir -p "huawei/fastlane"
    rm -f "huawei/fastlane/Fastfile" "huawei/fastlane/Appfile"
    ln -s "../../fastlane-builder/huawei/Fastfile" "huawei/fastlane/Fastfile"
    ln -s "../../fastlane-builder/huawei/Appfile" "huawei/fastlane/Appfile"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Add 'submodules: true' to your CI/CD checkout step"
echo "   2. Set required ENV variables (see fastlane-builder/README.md)"
echo "   3. Commit changes: git add . && git commit -m 'chore: add fastlane-builder'"
