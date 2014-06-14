class AddBodyToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :body, :text, default: ''
  end
end
