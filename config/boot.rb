require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

 # X is the major version, Y is the minor version, and Z is the patch 
ENV['VERSION'] = "v1.3.1.1  &copy Copyright Venue Software Corporation, 2010 - 2015. "

ENV['LICENSEE'] = "General Demo Service"

# Google Client side Geocoding
