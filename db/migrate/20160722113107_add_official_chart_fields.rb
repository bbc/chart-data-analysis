class AddOfficialChartFields < ActiveRecord::Migration
  def change
    add_column :tracks, :occ_product_id, :string, :unique => true
    add_column :tracks, :occ_image_url, :string
    add_column :tracks, :label, :string
  end
end
