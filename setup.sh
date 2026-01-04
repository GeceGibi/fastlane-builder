#!/bin/bash
set -e

echo "🚀 Fastlane Builder Setup"
echo "========================="

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
  echo "❌ pubspec.yaml not found. Run this script from Flutter project root."
  exit 1
fi

# Check if submodule already exists
if [ -d "fastlane-builder" ]; then
  echo "⚠️  fastlane-builder already exists. Updating..."
  git submodule update --remote fastlane-builder
else
  echo "📦 Adding fastlane-builder submodule..."
  git submodule add https://github.com/GeceGibi/fastlane-builder.git
fi

# Create ios/fastlane directory if not exists
echo "📁 Setting up iOS fastlane..."
mkdir -p ios/fastlane

# Remove old files and create symlinks for iOS
rm -f ios/fastlane/Fastfile ios/fastlane/Appfile
ln -s ../../fastlane-builder/ios/Fastfile ios/fastlane/Fastfile
ln -s ../../fastlane-builder/ios/Appfile ios/fastlane/Appfile

# Create android/fastlane directory if not exists
echo "📁 Setting up Android fastlane..."
mkdir -p android/fastlane

# Remove old files and create symlinks for Android
rm -f android/fastlane/Fastfile android/fastlane/Appfile
ln -s ../../fastlane-builder/android/Fastfile android/fastlane/Fastfile
ln -s ../../fastlane-builder/android/Appfile android/fastlane/Appfile

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Add 'submodules: true' to your CI/CD checkout step"
echo "   2. Set required ENV variables (see fastlane-builder/README.md)"
echo "   3. Commit changes: git add . && git commit -m 'chore: add fastlane-builder'"
