class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows do |t|
      t.bigint :follower_id, null: false
      t.bigint :followed_id, null: false
      t.timestamps
    end
    add_index :follows, [:follower_id, :followed_id], unique: true
    add_foreign_key :follows, :users, column: :follower_id
    add_foreign_key :follows, :users, column: :followed_id
  end
end
