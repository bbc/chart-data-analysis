class Chart < ActiveRecord::Base
  has_many :entries, class_name: "ChartEntry", foreign_key: "chart_id"
  default_scope { order(date: :asc) }

  def tupac_page
    "https://production.live.bbc.co.uk/music/charts/radio1/singles/#{date}/publish"
  end

  def official_chart_page
    datestr = official_chart_date.strftime("%Y%m%d")
    "http://www.officialcharts.com/charts/uk-top-40-singles-chart/#{datestr}/750140/"
  end
  
  def official_chart_id
    official_chart_date.strftime("7501-%Y%m%d")
  end

  def official_chart_date
    date+6
  end

  def to_s
    date.to_s
  end
  
  def to_param
    date.to_s
  end
end
