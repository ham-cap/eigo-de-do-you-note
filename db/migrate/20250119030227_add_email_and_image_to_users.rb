class AddEmailAndImageToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :email, :string
    add_column :users, :image, :string
  end
end
