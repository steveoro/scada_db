module ScadaDb


=begin

= Session model

  - version:  0.0.3
  - author:   Steve A.

=end
  class Session < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "sessions"
  end
end
