#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)

track_metadata = Track.all.map { |track| track.to_hash }

File.open("track-metadata.json", 'wb') do |file|
  file.write(
    JSON.pretty_generate(track_metadata)
  )
end
