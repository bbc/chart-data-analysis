class Track < ActiveRecord::Base
  has_many :entries, class_name: "ChartEntry"

  def tupac_page
    "https://production.live.bbc.co.uk/music/records/#{record_id}"
  end
  
  def ilm_info_page
    "http://desktopjukebox.broadchart.com/bbc/members/asset_info/#{ilm_id.sub('-','/')}"
  end
  
  def ilm_player_page
    (album_id,track_no) = ilm_id.split('-')
    "http://desktopjukebox.broadchart.com/bbc/members/player.cgi?album_id=#{album_id}&track_no=#{track_no}"
  end
  
  def image_url(size='64x64')
    unless attributes['image_url'].blank?
      attributes['image_url'].sub(/\d+x\d+/, size)
    end
  end
  
  def spotify_url
    "https://open.spotify.com/track/#{spotify_id}"
  end
  
  def amazon_url
    "http://www.amazon.co.uk/dp/#{amazon_id}"
  end
  
  def deezer_url
    "http://www.deezer.com/track/#{deezer_id}"
  end
  
  def to_hash
    attributes.to_hash
  end
end
