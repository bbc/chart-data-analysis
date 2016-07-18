class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.date :date, null: false, unique: true
      t.timestamps null: false
    end
  end
end
