class AddDiscussionsCountToWorkshops < ActiveRecord::Migration
  def self.up
    add_column :workshops, :discussions_count, :integer, null: false, default: 0
    ids = Set.new
    Discussion.all.each {|d| ids << d.workshop_id}
    ids.each do |workshop_id|
      Workshop.reset_counters(workshop_id, :discussions)
    end
  end
  def self.down
    remove_column :workshops, :discussions_count
  end
end
