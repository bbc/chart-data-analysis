#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)

require 'addressable'
require 'date'
require 'net/https'
require 'pp'

raise "Please set the HTTP_BROADCHART_USERNAME environment variable" unless ENV['HTTP_BROADCHART_USERNAME']
HTTP_BROADCHART_USERNAME = ENV['HTTP_BROADCHART_USERNAME']

raise "Please set the HTTP_BROADCHART_PASSWORD environment variable" unless ENV['HTTP_BROADCHART_PASSWORD']
HTTP_BROADCHART_PASSWORD = ENV['HTTP_BROADCHART_PASSWORD']



def http_get_html(uri)
  http = Net::HTTP.new(uri.host, uri.inferred_port)

  http.read_timeout = 30
  http.open_timeout = 10

  # Create the request
  req = Net::HTTP::Get.new(uri.request_uri)
  req.basic_auth(HTTP_BROADCHART_USERNAME, HTTP_BROADCHART_PASSWORD)
  response = http.request(req)

  # Check that the response is success
  if response.code == "200"
    Nokogiri::HTML.parse(response.body)
  else
    puts "=> #{response.code}"
  end
end


def parse_duration(str)
  if str =~ /^(\d\d):(\d\d)$/
    ($1.to_i * 60) + $2.to_i
  elsif str =~ /^(\d\d):(\d\d):(\d\d)$/
    ($1.to_i * 3600) + ($2.to_i * 60) + $3.to_i
  end
end

def fetch_metadata(track)
  puts "Fetching metadata for: #{track.ilm_id}"
  uri = Addressable::URI.parse(track.ilm_info_page)
  doc = http_get_html(uri)
  return if doc.nil?
  
  metadata = {}
  doc.css("#detailsContent li").each do |row|
    if row.at('label') and row.at('span')
      key = row.at('label').inner_text.strip.sub(/:$/, '')
      value = row.at('span').inner_text.strip
      metadata[key] = value
    end
  end

  track.ilm_isrc = metadata['ISRC']
  track.ilm_genre = metadata['Product Genre']
  track.ilm_year = metadata['Track Release Year']
  track.ilm_tunecode = metadata['PRS Tunecode']
  track.ilm_iswc = metadata['ISWC']
  track.ilm_duration = parse_duration(metadata['Duration'])
  track.save!

end


Track.all.each do |track|
  #if track.ilm_duration.nil? or track.ilm_duration == 0
    fetch_metadata(track)
  #end
end

