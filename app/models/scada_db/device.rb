module ScadaDb
  class Device < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "devices"
  end
end
