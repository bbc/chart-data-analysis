class Track < ActiveRecord::Base
  has_many :entries, class_name: "ChartEntry"

  def tupac_page
    "https://production.live.bbc.co.uk/music/records/#{record_id}"
  end
end
