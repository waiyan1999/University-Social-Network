# db/migrate/xxxxxx_create_posts.rb
class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.string :image_url
      t.timestamps
    end
  end
end

