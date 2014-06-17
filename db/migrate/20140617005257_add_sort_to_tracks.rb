class AddSortToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :sort, :integer, default: 0
  end
end
