class CreateAdminProfiles < ActiveRecord::Migration
  def change
    create_table :admin_profiles do |t|
      t.string :name
      t.references :user, index: true, unique: true

      t.timestamps
    end
  end
end
