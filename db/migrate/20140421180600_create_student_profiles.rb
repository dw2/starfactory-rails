class CreateStudentProfiles < ActiveRecord::Migration
  def change
    create_table :student_profiles do |t|
      t.string :name
      t.text :bio
      t.string :avatar
      t.references :user, index: true, unique: true

      t.timestamps
    end
  end
end
