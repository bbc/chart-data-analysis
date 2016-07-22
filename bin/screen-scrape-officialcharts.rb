#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)
require 'pp'

def process_chart_html(filename)
  puts "Parsing: #{filename}"
  output_filename = filename.sub('.html', '.json')
  return if File.exist?(output_filename)

  doc = Nokogiri::HTML(File.read(filename))
  article_date = doc.at('.article-date').inner_text.strip

  chart_id = doc.at('#this-chart-id')['value']
  chart = {:id => chart_id, :date => article_date, :entries => []}
  doc.css("table.chart-positions tr").each do |row|
    columns = row.css("td")
    next if columns.nil? or columns.empty?

    if columns[0].at('.position')
      track = columns[2].at('.track')

      if img = track.at('.cover/img')
        image_src = img['src'].sub('http://live.chartsdb.aws.occ.drawgroup.com/img/small?url=', '')
      end

      chart[:entries] << {
        :position => columns[0].inner_text.to_i,
        :last_week => columns[1].inner_text.strip,
        :peek_position => columns[3].inner_text.strip,
        :weeks_in_chart => columns[4].inner_text.strip,
        :product_id => columns[6].at('a')['data-productid'],
        :artist => track.at('.artist').inner_text.strip.titleize,
        :title => track.at('.title').inner_text.strip.titleize,
        :label => track.at('.label').inner_text.strip.titleize,
        :image_src => image_src
      }
    
    else
    
      # Look for external links
      if row.at('.spotify')
        chart[:entries].last[:spotify_url] = row.at('.spotify')['href']
      end
      if row.at('.deezer')
        chart[:entries].last[:deezer_url] = row.at('.deezer')['href']
      end
      if row.at('.itunes')
        chart[:entries].last[:itunes_url] = row.at('.itunes')['href']
      end
      if row.at('.amazon')
        chart[:entries].last[:amazon_url] = row.at('.amazon')['href']
      end

    end
    
    
  end

  File.open(output_filename, 'wb') do |file|
    file.print JSON.pretty_generate(chart)
  end
end


Dir.glob("official-chart-company/*.html").sort.each do |filename|
  process_chart_html(filename)
end

puts "Done."

