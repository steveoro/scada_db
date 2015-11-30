module ScadaDb
  class MemSlot < ActiveRecord::Base
    belongs_to :device
  end
end
