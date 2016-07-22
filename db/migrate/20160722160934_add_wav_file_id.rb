class AddWavFileId < ActiveRecord::Migration
  def change
    add_column :tracks, :wave_file_id, :string, :unique => true
  end
end
