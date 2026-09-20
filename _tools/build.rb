require "fileutils"

ROOT = File.expand_path("..", __dir__)

UPSTREAM  = File.join(ROOT, "upstream", "RmlUiDoc")
OVERRIDES = File.join(ROOT, "overrides")
BUILD     = File.join(ROOT, ".build")
SITE      = File.join(BUILD, "site")

abort "Upstream RmlUiDoc not found: #{UPSTREAM}" unless Dir.exist?(UPSTREAM)

puts "[build] Cleaning #{BUILD}"
FileUtils.rm_rf(BUILD)

puts "[build] Creating #{SITE}"
FileUtils.mkdir_p(SITE)

# ------------------------------------------------------------
# 1. Copy official RmlUiDoc
# ------------------------------------------------------------

puts "[build] Copying upstream RmlUiDoc"

Dir.children(UPSTREAM).each do |entry|
  source = File.join(UPSTREAM, entry)
  target = File.join(SITE, entry)

  FileUtils.cp_r(source, target)
end

# ------------------------------------------------------------
# 2. Apply project overrides
# ------------------------------------------------------------

if Dir.exist?(OVERRIDES)
  puts "[build] Applying overrides"

  Dir.children(OVERRIDES).each do |entry|
    source = File.join(OVERRIDES, entry)
    target = File.join(SITE, entry)

    FileUtils.mkdir_p(File.dirname(target))
    FileUtils.rm_rf(target)
    FileUtils.cp_r(source, target)
  end
end

puts "[build] Done"
puts "[build] Site source: #{SITE}"