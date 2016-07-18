class CreateChartEntries < ActiveRecord::Migration
  def change
    create_table :chart_entries do |t|
      t.integer :position, index: true, null: false
      t.references :chart, index: true, null: false
      t.references :track, index: true, null: false
      t.timestamps null: false
    end
    
    add_index(:chart_entries, [:position, :chart_id], unique: true)
  end
end
