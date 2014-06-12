class AddDiscussionsCountToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :discussions_count, :integer
  end
end
