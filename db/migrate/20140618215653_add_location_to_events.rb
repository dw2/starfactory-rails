class AddLocationToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :location, index: true, unique: true
    end
  end
  def down
    change_table :events do |t|
      t.remove :location_id
    end
  end
end
