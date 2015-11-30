module ScadaDb
  class LogMessage < ActiveRecord::Base
    belongs_to :device
  end
end
