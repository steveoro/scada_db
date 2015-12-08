module ScadaDb


=begin

= MemSlot model

  - version:  0.0.3
  - author:   Steve A.

=end
  class MemSlot < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "mem_slots"

    belongs_to :device, class_name: "ScadaDb::Device"
  end
end
