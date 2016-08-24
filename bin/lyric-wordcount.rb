#!/usr/bin/env ruby

words = {}

Dir.glob("lyrics/*.txt").each do |filename|
  File.open(filename) do |file|
    file.each_line do |line|
      line.gsub!(/[^\w\s]+/, '')
      line.split(/\s+/).map {|w| w.downcase}.each do |word|
        words[word] ||= 0
        words[word] += 1
      end
    end
  end
end


words.each_pair do |word,count|
  if count > 1 and word.length > 4
    puts [word, count].join(',')
  end
end
