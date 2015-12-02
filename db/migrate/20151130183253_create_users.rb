class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :description

      t.integer :lock_version, default: 0
      t.timestamps null: false
    end
  end
end
