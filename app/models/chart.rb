class Chart < ActiveRecord::Base
  has_many :entries, class_name: "ChartEntry", foreign_key: "chart_id"
  default_scope { order(date: :asc) }

  def tupac_page
    "https://production.live.bbc.co.uk/music/charts/radio1/singles/#{date}/publish"
  end
  
  def to_s
    date.to_s
  end
  
  def to_param
    date.to_s
  end
end
