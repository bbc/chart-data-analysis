#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)

require 'json'


def cleanup(str)
  str.downcase.
      gsub(/['\`\"]/, '').
      gsub(/[\,\.\-\_]/, ' ').
      gsub(/ and /, ' & ').
      gsub(/ +/, ' ').
      strip
end

Chart.all.each do |chart|
  puts "Processing: #{chart.date}"
  filename = "official-chart-company/#{chart.official_chart_id}.json"

  unless File.exist?(filename)
    puts "Warning: file does not exist: #{filename}"
    next
  end

  data = File.open(filename, 'rb') do |file|
    JSON.parse(file.read)
  end

  data['entries'].each do |entry|
    ce = chart.entries.where(:position => entry['position']).first
    next if ce.nil?
    next unless ce.track.occ_product_id.nil?
    
    artist = cleanup(entry['artist'])
    artist.sub!(/ Featuring .+$/i, '')
    artist.sub!(/ ft .+$/i, '')
    artist.sub!(/^The /i, '')
    
    title = cleanup(entry['title'])

    bbc_title = cleanup(ce.track.title)
    bbc_title.sub!(/ \(feat .+\)$/i, '')
    bbc_artist = cleanup(ce.track.artist)
    bbc_artist.sub!(/^The /i, '')
    
    if title == bbc_title and artist == bbc_artist
      ce.track.occ_product_id = entry['product_id']
      ce.track.occ_image_url = entry['image_url']
      ce.track.label ||= entry['label']
    else
      puts "Mismatch at #{ce.position}"
      puts "  BBC:     #{bbc_artist} / #{bbc_title}"
      puts "  Offical: #{artist} / #{title}"

      loop do
        puts "Is it a Match? (y/n/r/q)"
        chr = STDIN.getch.strip
        if chr == 'y'
          ce.track.occ_product_id = entry['product_id']
          ce.track.occ_image_url = entry['image_url']
          ce.track.label = entry['label']
          break
        elsif chr == 'r'
          ce.track = Track.find_or_initialize_by(:occ_product_id => entry['product_id'])
          ce.track.artist = entry['artist']
          ce.track.title = entry['title']
          ce.track.occ_image_url = entry['image_url']
          ce.track.label = entry['label']
          break
        elsif chr == 'n'
          break
        elsif chr == 'q'
          exit
        end
      end
    end

    ce.track.save!
    ce.save!
  end

end
