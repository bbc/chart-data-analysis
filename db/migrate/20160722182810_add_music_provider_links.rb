class AddMusicProviderLinks < ActiveRecord::Migration
  def change
    add_column :tracks, :amazon_id, :string, :index => true
    add_column :tracks, :itunes_url, :string, :index => true
    add_column :tracks, :deezer_id, :string, :index => true
    add_column :tracks, :spotify_id, :string, :index => true
  end
end
