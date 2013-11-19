Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-filter_keys"
  spec.version       = "0.0.2"
  spec.authors       = ["Kohei Hasegawa"]
  spec.email         = ["ameutau@gmail.com"]
  spec.description   = %q{Fluentd plugin to filter if a specific key is present or not in event logs.}
  spec.summary       = %q{Fluentd plugin to filter if a specific key is present or not in event logs.}
  spec.homepage      = "https://github.com/banyan/fluent-plugin-filter_keys"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fluentd"
end
