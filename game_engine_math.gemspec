# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require 'game_engine_math/version'

Gem::Specification.new do |s|
  s.name        = 'game_engine_math'
  s.version     = GameEngineMath::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Code based on Foundations of Game Engine Development'
  s.license     = 'BSD-3-Clause'
  s.description = 'Code based on Foundations of Game Engine Development'
  s.authors     = ['Jeremy Cole']
  s.email       = 'jeremy@jcole.us'
  s.homepage    = 'https://github.com/jeremycole/game_engine_math_ruby'
  s.files = Dir.glob('{lib}/**/*') + %w[LICENSE.md README.md]
  s.executables = []
  s.require_path = 'lib'

  s.add_development_dependency('rspec', '~> 3.8.0')
end
