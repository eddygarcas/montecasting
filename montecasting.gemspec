lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "montecasting/version"

Gem::Specification.new do |spec|
  spec.name          = "montecasting"
  spec.version       = Montecasting::VERSION
  spec.authors       = ["Eduard Garcia Castello"]
  spec.email         = ["edugarcas@gmail.com"]

  spec.summary       = %q{Ruby Gem for forecasting software projects (Work in progress)}
  spec.description   = %q{Montecasting will provide a set of forcasting techniques to be used on software project management or product development. This gem is on its early stages, I'll keep adding functionality on following months.}
  spec.homepage      = "https://github.com/eddygarcas/montecasting"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eddygarcas/montecasting"
  spec.metadata["changelog_uri"] = "https://github.com/eddygarcas/montecasting"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
