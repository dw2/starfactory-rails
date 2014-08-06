class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :description
      t.integer :amount_in_cents, default: 0
      t.datetime :expires_at
      t.references :event, index: true, unique: true

      t.timestamps
    end
  end
end
