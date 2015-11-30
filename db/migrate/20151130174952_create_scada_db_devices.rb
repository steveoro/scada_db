class CreateScadaDbDevices < ActiveRecord::Migration
  def change
    create_table :scada_db_devices do |t|
      t.text :description
      t.text :notes

      t.timestamps null: false
    end
  end
end
