class RemoveUnneededForeignKeysFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :admin_profile_id
    remove_column :users, :instructor_profile_id
    remove_column :users, :student_profile_id
  end

  def self.down
    add_column :users, :admin_profile_id, :integer
    add_column :users, :instructor_profile_id, :integer
    add_column :users, :student_profile_id, :integer
  end
end
