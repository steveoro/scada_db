class CreateMemSlots < ActiveRecord::Migration
  def change
    create_table :mem_slots do |t|
      t.string :msw, limit: 16
      t.string :lsw, limit: 16
      t.string :format, limit: 2
      t.text :description
      t.string :unit, limit: 8
      t.integer :decimals, limit: 2
      t.text :notes

      t.references :device, index: true, foreign_key: true, on_delete: :cascade

      t.integer :lock_version, default: 0
      t.timestamps null: false
    end

    add_index :mem_slots, :msw
    add_index :mem_slots, :lsw
    add_index :mem_slots, [:device_id, :msw, :lsw, :format],
              name: 'device_address', unique: true
  end
end
