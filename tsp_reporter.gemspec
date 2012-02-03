Gem::Specification.new do |s|
  s.name = "tps_reporter"
  s.version = "0.0.1"
  s.summary = %{Task progress sheet reporter.}
  s.description = %Q{A YAML-powered, simple command-line task report builder.}
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/rstacruz/proscribe"
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }

  s.add_dependency "tilt"
end
