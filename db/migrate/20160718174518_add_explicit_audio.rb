class AddExplicitAudio < ActiveRecord::Migration
  def change
    add_column :tracks, :explicit, :boolean
  end
end
