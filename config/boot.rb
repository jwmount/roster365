require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

ENV['VERSION'] = "v1.2.49. &copy Copyright Venue Software Corporation, 2010 - 2013. "
ENV['LICENSEE'] = 'Valley Farm Transport'
ENV['LICENSEE_LOB'] = "Farm Transport"
ENV['LICENSEE_URL'] = "www.ValleyTransport.com"
#LICENSEE = ENV['LICENSEE']
