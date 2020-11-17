class AddZielAndMemoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users,:ziel,:string
    add_column :users,:memo,:text
  end
end
