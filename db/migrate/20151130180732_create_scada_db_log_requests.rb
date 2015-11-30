class CreateScadaDbLogRequests < ActiveRecord::Migration
  def change
    create_table :scada_db_log_requests do |t|
      t.references :device, index: true, foreign_key: true
      t.string :sender
      t.string :receiver
      t.text :body

      t.timestamps null: false
    end
  end
end
