class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.string :name
      t.string :status, default: 'Active'
      t.integer :comments_count
      t.references :workshop, index: true, unique: true
      t.references :student_profile, index: true, unique: true
      t.references :instructor_profile, index: true, unique: true

      t.timestamps
    end
  end
end
