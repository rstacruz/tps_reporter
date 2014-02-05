require './lib/tps/version'

Gem::Specification.new do |s|
  s.name = "tps_reporter"
  s.version = TPS.version
  s.summary = %{Task progress sheet reporter.}
  s.description = %Q{A YAML-powered, simple command-line task report builder.}
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/rstacruz/tps_reporter"
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }
  s.license = 'MIT'

  s.add_dependency "tilt", "~> 1.4.1"
  s.add_dependency "haml", "~> 4.0.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest-reporters"
end
