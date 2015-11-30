class CreateScadaDbMemSlots < ActiveRecord::Migration
  def change
    create_table :scada_db_mem_slots do |t|
      t.string :msw, limit: 16
      t.string :lsw, limit: 16
      t.string :format, limit: 2
      t.text :description
      t.string :unit, limit: 8
      t.integer :decimals, limit: 2
      t.text :notes
      t.references :device, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :scada_db_mem_slots, :msw
    add_index :scada_db_mem_slots, :lsw
  end
end
