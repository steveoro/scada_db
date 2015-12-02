module ScadaDb
  class Session < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "sessions"
  end
end
