class AddNotNullConstraintToCards < ActiveRecord::Migration[7.2]
  def change
    change_column_null :cards, :user_id, false
  end
end
