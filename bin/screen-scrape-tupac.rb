#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)

# Certificate for accessing Forge APIs
raise "Please set the HTTPS_CERT_FILE environment variable" unless ENV['HTTPS_CERT_FILE']
HTTPS_CERT = File.read(ENV['HTTPS_CERT_FILE'])



def http_get_html(uri)
  http = Net::HTTP.new(uri.host, uri.inferred_port)
  if uri.scheme == "https"
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.key = OpenSSL::PKey::RSA.new(HTTPS_CERT)
    http.cert = OpenSSL::X509::Certificate.new(HTTPS_CERT)
  end

  http.read_timeout = 30
  http.open_timeout = 10

  # Create the request
  req = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(req)

  # Check that the response is success
  if response.code == "200"
    Nokogiri::HTML.parse(response.body)
  else
    puts "=> #{response.code}"
  end
end


def download_chart(date)
  puts "Fetching: #{date}"

  chart = Chart.where(:date => date).first_or_create
  uri = Addressable::URI.parse(chart.tupac_page)
  doc = http_get_html(uri)
  return if doc.nil?

  doc.css("#chartTable .entry-identifier").each do |row|
    edit_image = row.at(".image .imageLink").attributes['href'].value
    if edit_image =~ %r|/music/records/(\w+)/|
      record_id = $1
    else
      puts "Couldn't get record id"
      next
    end

    artist = row.at(".artistName .related")

    track = Track.where(record_id: record_id).first_or_initialize
    track.title = row.css(".artistName .principal").inner_text.strip
    track.artist = artist.inner_text.strip
    track.image_url = row.at(".image img").attributes['src'].value
    track.save!
    
    entry = chart.entries.where(
      :position => row.css(".position").inner_text.to_i
    ).first_or_initialize
    entry.track = track
    entry.save!
  end

end

# Chart was on Sundays from 3 August 1969 until 5 July 2015
date = Date.new(2010, 1, 3)
last_sunday = Date.new(2015, 7, 5)
while (date <= last_sunday)
  download_chart(date)
  date += 7
end

# Chart is on Friday from 10 July 2015 on wards
date = Date.new(2015, 7, 10)
while (date <= Date.today)
  download_chart(date)
  date += 7
end
