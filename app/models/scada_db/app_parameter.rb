module ScadaDb


=begin

= AppParameter model

  - version:  0.0.3
  - author:   Steve A.

=end
  class AppParameter < ActiveRecord::Base
    # Avoid module namespace in table names:
    self.table_name = "app_parameters"
                                # Required/expected param ID codes:
    CODE_VERSIONING = 1
    #-- -----------------------------------------------------------------------
    #++
  end
end
