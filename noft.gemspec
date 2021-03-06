# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name               = %q{noft}
  s.version            = '1.0.2'
  s.platform           = Gem::Platform::RUBY

  s.authors            = ['Peter Donald']
  s.email              = %q{peter@realityforge.org}

  s.homepage           = %q{https://github.com/realityforge/noft}
  s.summary            = %q{A tool to extract svg icons from icon fonts and generate helpers to render the icons.}
  s.description        = %q{A tool to extract svg icons from icon fonts and generate helpers to render the icons.}

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {spec}/*`.split("\n")
  s.executables        = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths      = %w(lib)

  s.rdoc_options       = %w(--line-numbers --inline-source --title noft)

  s.add_dependency 'reality-mda', '>= 1.8.0'
  s.add_dependency 'reality-core', '>= 1.8.0'
  s.add_dependency 'reality-facets', '>= 1.9.0'
  s.add_dependency 'reality-generators', '>= 1.14.0'
  s.add_dependency 'reality-naming', '>= 1.9.0'
  s.add_dependency 'reality-model', '>= 1.3.0'
  s.add_dependency 'reality-orderedhash', '>= 1.0.0'
  s.add_dependency 'schmooze', '= 0.1.6'

  s.add_development_dependency(%q<minitest>, ['= 5.9.1'])
  s.add_development_dependency(%q<test-unit>, ['= 3.1.5'])
end
