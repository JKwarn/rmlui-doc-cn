require "fileutils"

ROOT = File.expand_path("..", __dir__)

UPSTREAM  = File.join(ROOT, "upstream", "RmlUiDoc")
OVERRIDES = File.join(ROOT, "overrides")
BUILD     = File.join(ROOT, ".build")
SITE      = File.join(BUILD, "site")

# ------------------------------------------------------------
# Validation
# ------------------------------------------------------------

abort "Upstream RmlUiDoc not found: #{UPSTREAM}" unless Dir.exist?(UPSTREAM)

# ------------------------------------------------------------
# Merge directory tree
#
# Files/directories in source are merged into target.
#
# - Directories are merged recursively.
# - Files with the same path are replaced.
# - Files that only exist in target are preserved.
# ------------------------------------------------------------

def merge_tree(source, target)
  FileUtils.mkdir_p(target)

  Dir.children(source).each do |entry|
    source_path = File.join(source, entry)
    target_path = File.join(target, entry)

    if File.directory?(source_path) && !File.symlink?(source_path)
      # If target exists but is not a directory, replace it.
      if File.exist?(target_path) && !File.directory?(target_path)
        FileUtils.rm_rf(target_path)
      end

      merge_tree(source_path, target_path)
    else
      # Override an existing file/symlink with the source version.
      FileUtils.rm_rf(target_path)
      FileUtils.cp_r(source_path, target_path)
    end
  end
end

# ------------------------------------------------------------
# 1. Clean build directory
# ------------------------------------------------------------

puts "[build] Cleaning #{BUILD}"
FileUtils.rm_rf(BUILD)

# ------------------------------------------------------------
# 2. Create site directory
# ------------------------------------------------------------

puts "[build] Creating #{SITE}"
FileUtils.mkdir_p(SITE)

# ------------------------------------------------------------
# 3. Copy upstream RmlUiDoc
# ------------------------------------------------------------

puts "[build] Copying upstream RmlUiDoc"
merge_tree(UPSTREAM, SITE)

# ------------------------------------------------------------
# 4. Apply project overrides
# ------------------------------------------------------------

if Dir.exist?(OVERRIDES)
  puts "[build] Applying overrides"
  merge_tree(OVERRIDES, SITE)
else
  puts "[build] No overrides directory found"
end

# ------------------------------------------------------------
# 5. Validate assembled site
# ------------------------------------------------------------

required_files = [
  File.join(SITE, "_config.yml"),
  File.join(SITE, "_includes", "setup"),
  File.join(SITE, "_layouts", "default.html")
]

required_files.each do |file|
  abort "[build] Required file missing: #{file}" unless File.exist?(file)
end

# ------------------------------------------------------------
# Done
# ------------------------------------------------------------

puts "[build] Done"
puts "[build] Site source: #{SITE}"