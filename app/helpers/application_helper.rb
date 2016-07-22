module ApplicationHelper
  def format_duration(secs)
    sprintf("%2.2d:%2.2d", secs.div(60), secs % 60)
  end
end
