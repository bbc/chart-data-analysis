class ChartEntry < ActiveRecord::Base
  belongs_to :chart
  belongs_to :track
  default_scope { order(position: :asc) }
end
