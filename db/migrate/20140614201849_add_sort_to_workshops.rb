class AddSortToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :sort, :integer, default: 0
  end
end
