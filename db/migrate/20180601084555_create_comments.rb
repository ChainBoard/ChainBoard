class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :body
      t.string :user_display_name
      t.string :user_name

      t.timestamps
    end
  end
end
