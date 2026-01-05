require 'fileutils'

def log_info(message)
  UI.message("📝 #{message}")
end

def env_with_flavor(key)
  flavor = ENV['FLAVOR']
  value = nil
  if flavor && !flavor.empty?
    flavor_key = "#{flavor.upcase}_#{key}"
    value = ENV[flavor_key] if ENV[flavor_key] && !ENV[flavor_key].empty?
  end
  value = ENV[key] if value.nil?
  value
end

def find_project_root
  dir = Dir.pwd
  while dir != '/'
    return dir if File.exist?(File.join(dir, 'pubspec.yaml'))
    dir = File.dirname(dir)
  end
  nil
end

def get_metadata_path(platform_prefix, project_root)
  default_subpath = platform_prefix.downcase == 'android' ? "android/fastlane/metadata" : "ios/fastlane/metadata"
  full_path = File.expand_path(default_subpath, project_root)
  nested_path = File.join(full_path, platform_prefix.downcase)
  
  final_path = Dir.exist?(nested_path) ? nested_path : full_path
  log_info("Metadata Path resolved to: #{final_path}")
  final_path
end

def ensure_metadata_dirs(platform_prefix, project_root)
  log_info("Checking metadata directories...")
  metadata_path = get_metadata_path(platform_prefix, project_root)
  
  locales_env = env_with_flavor("SUPPORTED_LOCALES") || "tr-TR"
  locales = locales_env.split(',').map(&:strip)
  
  log_info("Supported locales: #{locales}")

  is_android_style = platform_prefix.upcase == 'ANDROID' # Android/Huawei share this usually, but Huawei uses changelog.txt
  
  # Logic to determine file path based on platform
  # iOS: metadata/<locale>/release_notes.txt
  # Android: metadata/<locale>/changelogs/default.txt
  # Huawei: metadata/<locale>/changelog.txt (Actually our current code used this for Huawei)
  
  # However, to keep it simple, let's pass the styling or rely on the prefix logic we had.
  # Let's standardize:
  # iOS -> release_notes.txt
  # Android -> changelogs/default.txt
  # Huawei -> changelog.txt

  locales.each do |locale|
    dir = File.join(metadata_path, locale)
    
    file_path = nil
    if platform_prefix.upcase == 'IOS'
      FileUtils.mkdir_p(dir)
      file_path = File.join(dir, "release_notes.txt")
    elsif platform_prefix.upcase == 'ANDROID'
      dir = File.join(dir, "changelogs")
      FileUtils.mkdir_p(dir)
      file_path = File.join(dir, "default.txt")
    elsif platform_prefix.upcase == 'HUAWEI' # Huawei
       FileUtils.mkdir_p(dir)
       file_path = File.join(dir, "changelog.txt")
    else
       # Fallback or error
       FileUtils.mkdir_p(dir)
       file_path = File.join(dir, "release_notes.txt")
    end

    unless File.exist?(file_path)
      log_info("⚠️ Metadata file missing for #{locale} at #{file_path}. Skipping creation.")
    end
  end

  # Cleanup disabled by user request
  # if Dir.exist?(metadata_path)
  #   existing_dirs = Dir.children(metadata_path).select { |d| File.directory?(File.join(metadata_path, d)) }
  #   to_remove = existing_dirs - locales
  #   to_remove.each do |dir_name|
  #     next if dir_name.start_with?('.') # Skip hidden files
  #     next if dir_name == 'default' # Skip default directory, it's valid for Apple
  #     full_path = File.join(metadata_path, dir_name)
  #     log_info("Removing unsupported locale directory: #{dir_name}")
  #     FileUtils.rm_rf(full_path)
  #   end
  # end
end

def dump_context(platform_name, specific_keys = [])
  UI.message("----------------------------------------------------")
  UI.message("🛠️  #{platform_name} Build Context Dump")
  UI.message("----------------------------------------------------")
  
  keys = [
    'FLAVOR',
    'SUPPORTED_LOCALES',
    'AUTO_GENERATE_CHANGELOG'
  ] + specific_keys
  
  flavor = ENV['FLAVOR']
  if flavor && !flavor.empty?
    keys += keys.map { |k| "#{flavor.upcase}_#{k}" }
  end

  keys.uniq.each do |key|
    value = ENV[key]
    if value && !value.empty?
      masked = (key.include?('SECRET') || key.include?('JSON') || key.include?('KEY') || key.include?('CONTENT')) && value.length > 20 ? "#{value[0..4]}...#{value[-4..-1]}" : value
      UI.message("   🔹 #{key}: #{masked}")
    # else
      # UI.message("   🔸 #{key}: [nil/empty]")
    end
  end

  UI.message("   -- Metadata Files --")
  root = ENV["GITHUB_WORKSPACE"] || ENV["CI_PROJECT_DIR"] || ENV["BUILD_SOURCESDIRECTORY"] || find_project_root
  
  if root
    # Determine platform prefix for get_metadata_path logic
    prefix = 'IOS'
    prefix = 'ANDROID' if platform_name.downcase.include?('android') || platform_name.downcase.include?('huawei') 
    # Note: Huawei uses ANDROID style path generally in our setup "android/fastlane/metadata"
    
    m_path = get_metadata_path(prefix, root)
    if Dir.exist?(m_path)
      Dir.children(m_path).each do |locale|
        next if locale.start_with?('.')
        
        # Determine specific file to check based on platform name passed
        file_path = nil
        if platform_name.downcase == 'ios'
           file_path = File.join(m_path, locale, "release_notes.txt")
        elsif platform_name.downcase == 'android'
           file_path = File.join(m_path, locale, "changelogs", "default.txt")
        elsif platform_name.downcase == 'huawei'
           file_path = File.join(m_path, locale, "changelog.txt")
        end

        if file_path && File.exist?(file_path)
          content = File.read(file_path)
          UI.message("   📂 #{locale}: #{file_path}")
          UI.message("      └── Size: #{content.bytesize} bytes | Chars: #{content.length}")
        else
           UI.message("   📂 #{locale}: [File not found or pattern mismatch]")
        end
      end
    else
       UI.message("   ⚠️ Metadata path not found at: #{m_path}")
    end
  end
  UI.message("----------------------------------------------------")
end

def update_changelog_from_git(platform_prefix, project_root)
  if env_with_flavor('AUTO_GENERATE_CHANGELOG') != 'true'
    log_info("Skipping automatic changelog generation (AUTO_GENERATE_CHANGELOG is not 'true').")
    return
  end

  log_info("Updating changelog from Git history (Last 10 commits)...")
  
  # Get last 10 commits: "- Commit message (Author)"
  changelog_text = `git log -10 --pretty=format:"- %s (%an)"`
  
  if changelog_text.empty?
    log_info("⚠️ No git commits found to generate changelog.")
    return
  end
  
  metadata_path = get_metadata_path(platform_prefix, project_root)
  
  locales_env = env_with_flavor("SUPPORTED_LOCALES") || "tr-TR"
  locales = locales_env.split(',').map(&:strip)
  
  locales.each do |locale|
    file_path = nil
    if platform_prefix.upcase == 'IOS'
      file_path = File.join(metadata_path, locale, "release_notes.txt")
    elsif platform_prefix.upcase == 'ANDROID'
      file_path = File.join(metadata_path, locale, "changelogs", "default.txt")
    elsif platform_prefix.upcase == 'HUAWEI'
      file_path = File.join(metadata_path, locale, "changelog.txt")
    end
    
    if file_path && File.exist?(file_path)
      # Append timestamp header
      header = "Build Logs (#{Time.now.strftime('%Y-%m-%d %H:%M')}):"
      new_content = "#{header}\n#{changelog_text}"
      
      File.write(file_path, new_content)
      log_info("Updated #{locale} changelog: \n#{new_content}")
    end
  end
end
