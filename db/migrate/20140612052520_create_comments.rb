class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.string :status, default: 'Published'
      t.references :discussion, index: true, unique: true
      t.references :comment, index: true, unique: true
      t.references :student_profile, index: true, unique: true
      t.references :instructor_profile, index: true, unique: true

      t.timestamps
    end
  end
end
