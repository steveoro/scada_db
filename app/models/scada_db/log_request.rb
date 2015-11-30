module ScadaDb
  class LogRequest < ActiveRecord::Base
    belongs_to :device
  end
end
