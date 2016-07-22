#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)

require 'json'


Dir.glob("official-chart-company/*.json").each do |filename|

  data = File.open(filename, 'rb') do |file|
    JSON.parse(file.read)
  end

  data['entries'].each do |entry|
    puts "Updating: #{entry['product_id']}"

    Track.where(:occ_product_id => entry['product_id']).each do |track|
      track.occ_image_url = entry['image_url']
      track.label = entry['label']
    
      if entry['itunes_url']
        track.itunes_url = entry['itunes_url']
      end
    
      if entry['deezer_url'] =~  %r|/track/(\w+)|
        track.deezer_id = $1
      end

      if entry['amazon_url'] =~ %r|/dp/(\w+)|
        track.amazon_id = $1
      end
    
      if entry['spotify_url'] =~ %r|/track/(\w+)|
        track.spotify_id = $1
      end
   
      track.save!
    end

  end

end

