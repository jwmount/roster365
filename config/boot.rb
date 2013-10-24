require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

ENV['TITLE'] = 'Roster365'
ENV['VERSION'] = '1.2.0.' + 'Copyright(c) Venuesoftware Corporation, 2010 - 2013. '

