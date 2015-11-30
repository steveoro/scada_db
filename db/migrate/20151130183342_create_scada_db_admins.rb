class CreateScadaDbAdmins < ActiveRecord::Migration
  def change
    create_table :scada_db_admins do |t|
      t.string :email
      t.string :description
      t.string :encrypted_password

      t.timestamps null: false
    end
  end
end
