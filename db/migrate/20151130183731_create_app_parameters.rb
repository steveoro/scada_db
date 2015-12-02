class CreateAppParameters < ActiveRecord::Migration
  def change
    create_table :app_parameters do |t|
      t.integer :code
      t.string :str_1
      t.string :str_2
      t.string :str_3
      t.boolean :bool_1
      t.boolean :bool_2
      t.boolean :bool_3
      t.integer :int_1
      t.integer :int_2
      t.integer :int_3
      t.text :description

      t.integer :lock_version, default: 0
      t.timestamps null: false
    end

    add_index :app_parameters, :code, unique: true
  end
end
