module ScadaDb
  class MemSlot < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "mem_slots"

    belongs_to :device, class_name: "ScadaDb::Device"
  end
end
