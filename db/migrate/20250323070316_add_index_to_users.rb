class AddIndexToUsers < ActiveRecord::Migration[7.2]
  def change
    add_index :users, %i[uid provider], unique: true
  end
end
