class AddStripeTokenToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :stripe_token, :string
  end
end
