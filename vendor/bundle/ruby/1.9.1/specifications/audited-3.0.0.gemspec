# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "audited"
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brandon Keepers", "Kenneth Kalmer", "Daniel Morrison", "Brian Ryckbost", "Steve Richert", "Ryan Glover"]
  s.date = "2012-09-25"
  s.description = "Log all changes to your models"
  s.email = "info@collectiveidea.com"
  s.homepage = "https://github.com/collectiveidea/audited"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Log all changes to your models"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<activerecord>, ["~> 3.0"])
      s.add_development_dependency(%q<appraisal>, ["~> 0.4"])
      s.add_development_dependency(%q<bson_ext>, ["~> 1.6"])
      s.add_development_dependency(%q<mongo_mapper>, ["~> 0.11"])
      s.add_development_dependency(%q<rails>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.0"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.0"])
    else
      s.add_dependency(%q<activerecord>, ["~> 3.0"])
      s.add_dependency(%q<appraisal>, ["~> 0.4"])
      s.add_dependency(%q<bson_ext>, ["~> 1.6"])
      s.add_dependency(%q<mongo_mapper>, ["~> 0.11"])
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.0"])
      s.add_dependency(%q<sqlite3>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 3.0"])
    s.add_dependency(%q<appraisal>, ["~> 0.4"])
    s.add_dependency(%q<bson_ext>, ["~> 1.6"])
    s.add_dependency(%q<mongo_mapper>, ["~> 0.11"])
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.0"])
    s.add_dependency(%q<sqlite3>, ["~> 1.0"])
  end
end
