module ScadaDb


=begin

= LogMessage model

  - version:  0.0.3
  - author:   Steve A.

=end
  class LogMessage < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "log_messages"

    belongs_to :device, class_name: "ScadaDb::Device"
  end
end
