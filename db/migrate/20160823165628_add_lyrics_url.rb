class AddLyricsUrl < ActiveRecord::Migration
  def change
    add_column :tracks, :lyrics_url, :string, :index => true
  end
end
