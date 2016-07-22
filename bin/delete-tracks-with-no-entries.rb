#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)

require 'pp'


Track.all.each do |track|
  next unless track.entries.blank?

  puts "Deleting: #{track}"
  track.delete
end
