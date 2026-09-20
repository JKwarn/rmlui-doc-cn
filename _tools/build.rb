require "fileutils"

ROOT = File.expand_path("..", __dir__)
UPSTREAM = File.join(ROOT, "upstream", "RmlUiDoc")
BUILD = File.join(ROOT, ".build")
SITE = File.join(BUILD, "site")

abort "Upstream RmlUiDoc not found: #{UPSTREAM}" unless Dir.exist?(UPSTREAM)

puts "[build] Cleaning #{BUILD}"
FileUtils.rm_rf(BUILD)

puts "[build] Creating #{SITE}"
FileUtils.mkdir_p(SITE)

puts "[build] Copying upstream RmlUiDoc"
FileUtils.cp_r(
  Dir.glob(File.join(UPSTREAM, "*"), File::FNM_DOTMATCH),
  SITE
)

puts "[build] Done"
puts "[build] Site source: #{SITE}"