# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_plant/version'

Gem::Specification.new do |gem|
  gem.name          = "gem_plant"
  gem.version       = GemPlant::VERSION
  gem.authors       = ["Takahiro HAMAGUCHI"]
  gem.email         = ["tk_hamaguchi@xml-lab.jp"]
  gem.description   = %q{Gem template generator}
  gem.summary       = %q{Gem template generator.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "thor", '~>0.17.0'

end
