class CreateLogRequests < ActiveRecord::Migration
  def change
    create_table :log_requests do |t|
      t.integer :seq, limit: 8
      t.string :sender
      t.string :receiver
      t.text :body

      t.references :device, index: true, foreign_key: true, on_delete: :cascade

      t.integer :lock_version, default: 0
      t.timestamps null: false
    end

    add_index :log_requests, :sender
    add_index :log_requests, :receiver
    add_index :log_requests, [:device_id, :sender, :receiver, :seq], name: 'idx_req_sender_receiver'
  end
end
