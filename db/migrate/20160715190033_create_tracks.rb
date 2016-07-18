class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :artist
      t.string :title
      t.string :image_url
      t.string :record_id
      t.integer :rebox_id
      t.string :ilm_isrc
      t.string :ilm_id
      t.string :ilm_genre
      t.string :ilm_year
      t.string :ilm_tunecode
      t.string :ilm_iswc
      t.integer :ilm_duration
      t.timestamps null: false
    end
  end
end
