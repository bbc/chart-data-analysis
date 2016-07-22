#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)

url = 'http://www.officialcharts.com/charts/uk-top-40-singles-chart/'

loop do
  puts "Downloading: #{url}"
  system(
    'curl',
    '--fail',
    '--silent',
    '--location',
    '-o', "occ-temp.html",
    url,
  ) or raise "Failed to download chart"


  doc = Nokogiri::HTML(File.read('occ-temp.html'))

  # Check the filename against the date range in the file
  article_date = doc.at('.article-date').inner_text.strip
  (start_date, end_date) = article_date.split(' - ').map {|dstr| Date.parse(dstr)}
  puts "Title: #{start_date} - #{end_date}"

  chart_id = doc.at('#this-chart-id')['value']
  puts "Chart ID: #{chart_id}"
  if chart_id != end_date.strftime("7501-%Y%m%d")
    raise "Warning: Chart ID does not match End Date"
    return
  end
  
  File.rename('occ-temp.html', "official-chart-company/#{chart_id}.html")

  puts 

  # Get the date of the next chart
  next_tag = doc.at('.prev')
  if next_tag and next_tag['href']
    url = 'http://www.officialcharts.com' + next_tag['href']
  else
    puts "Done."
    break
  end
end
