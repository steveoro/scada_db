module ScadaDb
  class LogRequest < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "log_requests"

    belongs_to :device, class_name: "ScadaDb::Device"
  end
end
