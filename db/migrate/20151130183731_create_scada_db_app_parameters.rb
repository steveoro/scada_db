class CreateScadaDbAppParameters < ActiveRecord::Migration
  def change
    create_table :scada_db_app_parameters do |t|
      t.integer :code
      t.string :a_string
      t.boolean :a_bool
      t.integer :a_integer
      t.text :description

      t.timestamps null: false
    end
  end
end
