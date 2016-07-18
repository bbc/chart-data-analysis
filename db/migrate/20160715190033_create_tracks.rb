class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :artist
      t.string :title
      t.integer :position
      t.string :broadchart_id
      t.string :broadchart_album
      t.string :record_id
      t.string :image_url
      t.integer :rebox_id
      t.timestamps null: false
    end
  end
end
