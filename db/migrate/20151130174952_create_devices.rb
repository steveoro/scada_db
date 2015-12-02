class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.text :description
      t.text :notes

      t.integer :lock_version, default: 0
      t.timestamps null: false
    end

    add_index :devices, :name, unique: true
  end
end
