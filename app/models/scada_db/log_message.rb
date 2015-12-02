module ScadaDb
  class LogMessage < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "log_messages"

    belongs_to :device, class_name: "ScadaDb::Device"
  end
end
