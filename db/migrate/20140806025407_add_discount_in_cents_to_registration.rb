class AddDiscountInCentsToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :discount_in_cents, :integer, default: 0
  end
end
