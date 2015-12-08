module ScadaDb


=begin

= LogRequest model

  - version:  0.0.3
  - author:   Steve A.

=end
  class LogRequest < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "log_requests"

    belongs_to :device, class_name: "ScadaDb::Device"
  end
end
