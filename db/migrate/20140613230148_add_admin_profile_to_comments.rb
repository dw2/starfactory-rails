class AddAdminProfileToComments < ActiveRecord::Migration
  def change
    change_table :comments do |t|
      t.references :admin_profile, index: true, unique: true
    end
  end
  def down
    change_table :comments do |t|
      t.remove :admin_profile_id
    end
  end
end
