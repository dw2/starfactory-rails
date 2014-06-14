class AddAdminProfileToDiscussions < ActiveRecord::Migration
  def change
    change_table :discussions do |t|
      t.references :admin_profile, index: true, unique: true
    end
  end
  def down
    change_table :discussions do |t|
      t.remove :admin_profile_id
    end
  end
end
