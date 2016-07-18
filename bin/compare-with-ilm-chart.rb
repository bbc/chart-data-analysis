#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)

require 'json'

Chart.all.each do |chart|
  filename = "/Users/humfrn01/Box Sync/Charts Archive/DesktopJukebox/#{chart.date}.json"
  puts "Processing: #{filename}"

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
    next unless ce.track.ilm_id.nil?
    
    artist = entry['artist'].downcase
    artist.sub!(/ Featuring .+$/i, '')
    artist.sub!(/ Feat\. .+$/i, '')
    artist.sub!(/ And /i, ' & ')
    artist.sub!(/^The /i, ' ')
    artist.gsub!(/[\,\.\-\_]/, ' ')
    artist.gsub!(/ +/, ' ')
    
    title = entry['title'].downcase
    title.sub!(/ \(Short Radio Edit\)$/i, '')
    title.sub!(/ \(Radio Edit\)$/i, '')
    title.sub!(/ \(Clean Radio Edit\)$/i, '')
    title.sub!(/ \(UK Radio Edit\)$/i, '')
    title.sub!(/ \(Single\)$/i, '')
    title.sub!(/ \(UK Single\)$/i, '')
    title.sub!(/ \(edit\)$/i, '')
    title.sub!(/ \(\w+ version\)$/i, '')
    title.sub!(/ \(\w+ edit\)$/i, '')
    title.sub!(/ \(\w+ mix\)$/i, '')
    title.gsub!(/[\,\.\-\_]/, ' ')
    title.gsub!(/ +/, ' ')
    
    bbc_title = ce.track.title.downcase
    bbc_title.sub!(/ \(feat\. .+\)$/i, '')
    bbc_title.gsub!(/[\,\.\-\_]/, ' ')
    bbc_title.gsub!(/ +/, ' ')

    bbc_artist = ce.track.artist.downcase
    bbc_artist.sub!(/^The /i, ' ')
    bbc_artist.sub!(/ And /i, ' & ')
    bbc_artist.gsub!(/[\,\.\-\_]/, ' ')
    bbc_artist.gsub!(/ +/, ' ')
    
    if title == bbc_title and artist == bbc_artist
      ce.track.ilm_id = entry['id'].sub('/', '-')
    else
      puts "BBC: #{bbc_artist} / #{bbc_title}"
      puts "ILM: #{artist} / #{title}"
      
      loop do
        puts "Is it a Match? (y/n/q)"
        chr = STDIN.getch.strip
        if chr == 'y'
          ce.track.ilm_id = entry['id'].sub('/', '-')
          
          if entry['title'] =~ /explicit/i
            ce.track.explicit = true
          elsif entry['title'] =~ /radio edit\)/i
            ce.track.explicit = false
          elsif entry['title'] =~ /clean edit\)/i
            ce.track.explicit = false
          end
          break
        elsif chr == 'n'
          break
        elsif chr == 'q'
          exit
        end
      end
    end

    ce.track.save!
  end

end
