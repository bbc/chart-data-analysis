class Track < ActiveRecord::Base
  has_many :entries, class_name: "ChartEntry"

  def tupac_page
    "https://production.live.bbc.co.uk/music/records/#{record_id}"
  end
  
  def image_url(size='64x64')
    attributes['image_url'].sub(/\d+x\d+/, size)
  end
end
