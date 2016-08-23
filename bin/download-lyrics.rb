#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)

require 'json'
require 'net/http'



def http_download(uri)
  uri = URI.parse(uri)
  http = Net::HTTP.new(uri.host, uri.port)

  http.read_timeout = 30
  http.open_timeout = 10

  # Create the request
  req = Net::HTTP::Get.new(uri.request_uri)
  req['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36'
  response = http.request(req)

  # Check that the response is success
  if response.code == "200"
    Nokogiri::HTML.parse(response.body)
  else
    puts "=> #{response.code}"
  end
end


Track.where("lyrics_url IS NOT NULL AND record_id IS NOT NULL").each do |track|
  filename = "lyrics/#{track.record_id}.txt"
  
  unless File.exist?(filename)
    puts "Fetching: #{track.lyrics_url}"
    doc = http_download(track.lyrics_url)
    lyrics = doc.at('.lyricbox')
    lyrics.xpath('//comment()').remove
    lyrics.at('.lyricsbreak').remove
    lyrics.css('br').each{ |br| br.replace "\n" }
    
    File.open(filename, 'wb') do |file|
      file.write(lyrics.inner_text)
    end
  end
  
  sleep(0.7)
end
