# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nested_has_many_through"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian White"]
  s.date = "2011-04-16"
  s.description = "This plugin makes it possible to define has_many :through relationships that\n  go through other has_many :through relationships, possibly through an arbitrarily deep hierarchy.\n  This allows associations across any number of tables to be constructed, without having to resort to\n  find_by_sql (which isn't a suitable solution if you need to do eager loading through :include as well)."
  s.email = ["ian.w.white@gmail.com"]
  s.homepage = "http://twitter.com/i2w"
  s.require_paths = ["lib"]
  s.rubyforge_project = "nested_has_many_through"
  s.rubygems_version = "1.8.25"
  s.summary = "Rails gem that allows has_many :through to go through other has_many :throughs"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.5.0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.5.0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
  end
end
