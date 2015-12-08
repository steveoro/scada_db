module ScadaDb


=begin

= Device model

  - version:  0.0.3
  - author:   Steve A.

=end
  class Device < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "devices"
  end
end
