# Shared helper methods for Fastlane platforms
# These methods are used across Android, iOS, and Huawei Fastfiles

# Fetches ENV variable with flavor prefix support
# Example: FLAVOR=prod -> checks PROD_KEY, then KEY
def env_with_flavor(key)
  flavor = ENV['FLAVOR']
  if flavor && !flavor.empty?
    flavor_key = "#{flavor.upcase}_#{key}"
    return ENV[flavor_key] if ENV[flavor_key] && !ENV[flavor_key].empty?
  end
  ENV[key]
end

# Recursively searches up for pubspec.yaml to identify Flutter root
def find_project_root
  dir = Dir.pwd
  while dir != '/'
    return dir if File.exist?(File.join(dir, 'pubspec.yaml'))
    dir = File.dirname(dir)
  end
  nil
end

# Locates the most recently modified AAB file in the build directory
def find_latest_aab(project_root)
  aab_pattern = File.join(project_root, "build/app/outputs/bundle/**/*.aab")
  aab_files = Dir.glob(aab_pattern)
  return aab_files.max_by { |f| File.mtime(f) }
end

# Locates the most recently modified IPA file in the build directory
def find_latest_ipa(project_root)
  ipa_pattern = File.join(project_root, "build/ios/ipa/**/*.ipa")
  ipa_files = Dir.glob(ipa_pattern)
  return ipa_files.max_by { |f| File.mtime(f) }
end

# Resolves the absolute path for metadata directory
def get_metadata_path(platform_prefix, project_root)
  default_subpath = platform_prefix.downcase == 'android' ? "android/fastlane/metadata" : "ios/fastlane/metadata"
  relative_path = env_with_flavor("#{platform_prefix}_METADATA_PATH") || default_subpath
  full_path = File.expand_path(relative_path, project_root)

  # Detect redundant platform folder (e.g., metadata/android/tr-TR)
  # This prevents supply from treating 'android' as a language code
  nested_path = File.join(full_path, platform_prefix.downcase)
  return nested_path if Dir.exist?(nested_path)

  full_path
end

# Retrieves release notes text from a file or uses default
def get_changelog(platform_prefix, project_root)
  metadata_path = get_metadata_path(platform_prefix, project_root)
  changelog_file = File.join(metadata_path, "changelog.txt")

  if File.exist?(changelog_file) && !File.read(changelog_file).strip.empty?
    return File.read(changelog_file).strip
  else
    return "- Performance improvements and bug fixes."
  end
end
