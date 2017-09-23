class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :emailid
      t.string :contactno
      t.string :credate
      t.string :password
      t.boolean :verified
      t.boolean :isadmin

      t.timestamps
    end
  end
end
