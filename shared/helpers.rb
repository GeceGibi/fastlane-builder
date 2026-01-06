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
  return value
end

def find_project_root
  dir = Dir.pwd
  while dir != '/'
    return dir if File.exist?(File.join(dir, 'pubspec.yaml'))
    dir = File.dirname(dir)
  end
  return nil
end

def get_metadata_path(platform_prefix, project_root)
  default_subpath = platform_prefix.downcase == 'android' ? "android/fastlane/metadata" : "ios/fastlane/metadata"
  full_path = File.expand_path(default_subpath, project_root)
  nested_path = File.join(full_path, platform_prefix.downcase)
  
  final_path = Dir.exist?(nested_path) ? nested_path : full_path
  log_info("Metadata Path resolved to: #{final_path}")
  return final_path
end

def ensure_metadata_dirs(platform_prefix, project_root)
  log_info("Checking metadata directories...")
  metadata_path = get_metadata_path(platform_prefix, project_root)
  
  if Dir.exist?(metadata_path)
    log_info("Metadata directory found at: #{metadata_path}")
    log_info("Fastlane will use existing metadata configurations.")
  else
    log_info("⚠️ Metadata directory not found at: #{metadata_path}")
  end
end

def dump_context(platform_name, specific_keys = [])
  UI.message("----------------------------------------------------")
  UI.message("🛠️  #{platform_name} Build Context Dump")
  UI.message("----------------------------------------------------")
  
  keys = [
    'FLAVOR',
    'AUTO_GENERATE_CHANGELOG'
  ] + specific_keys
  
  keys.uniq.each do |key|
    value = env_with_flavor(key)
    if value && !value.empty?
      masked = (key.include?('SECRET') || key.include?('JSON') || key.include?('KEY') || key.include?('CONTENT')) && value.length > 20 ? "#{value[0..4]}...#{value[-4..-1]}" : value
      UI.message("   🔹 #{key}: #{masked}")
    end
  end

  UI.message("   -- Metadata Files --")
  root = ENV["GITHUB_WORKSPACE"] || ENV["CI_PROJECT_DIR"] || ENV["BUILD_SOURCESDIRECTORY"] || find_project_root
  
  if root
    # Determine platform prefix for get_metadata_path logic
    prefix = 'IOS'
    prefix = 'ANDROID' if platform_name.downcase.include?('android')
    
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
  
  if Dir.exist?(metadata_path)
    Dir.children(metadata_path).each do |locale|
      next if locale.start_with?('.')

      file_path = nil
      if platform_prefix.upcase == 'IOS'
        file_path = File.join(metadata_path, locale, "release_notes.txt")
      elsif platform_prefix.upcase == 'ANDROID'
        file_path = File.join(metadata_path, locale, "changelogs", "default.txt")
      end
      
      if file_path && File.exist?(file_path)
        # Append timestamp header
        header = "Build Logs (#{Time.now.strftime('%Y-%m-%d %H:%M')}):"
        new_content = "#{header}\n#{changelog_text}"
        
        File.write(file_path, new_content)
        log_info("Updated #{locale} changelog: \n#{new_content}")
      end
    end
  else
    log_info("⚠️ Metadata directory not found, skipping changelog update.")
  end
end
