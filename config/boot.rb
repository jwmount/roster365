require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

ENV['VERSION'] = "v1.2.63a. &copy Copyright Venue Software Corporation, 2010 - 2014. "

ENV['LICENSEE'] = "Valley Farm Transport"

# Google Client side Geocoding
# https://maps.googleapis.com/maps/api/geocode/json?address=5+St+Kilda+Ave.,+Broad+Beach,QLD,Postal_code+4218,Australia,&sensor=false&key=AIzaSyDVUWaiCEzOlXjYsSCJaKlAOwKcnqDA7Cs
# This is key used for Daycare-Decisions, may neet to get another one?
ENV['google_api_key'] = "AIzaSyDVUWaiCEzOlXjYsSCJaKlAOwKcnqDA7Cs"