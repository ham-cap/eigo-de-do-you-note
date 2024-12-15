class CreateCards < ActiveRecord::Migration[7.2]
  def change
    create_table :cards do |t|
      t.text :ja_phrase, null: false
      t.text :en_phrase, null: false
      t.datetime :memorized_at

      t.timestamps
    end
  end
end
