=begin

= Version module

  - version:  1.00.001
  - author:   Steve A.

  Semantic Versioning implementation.
=end
module ScadaDb
  # Major version.
  VERSION_MAJOR   = '0'

  # Minor version.
  VERSION_MINOR   = '0.2'

  # Current build version.
  VERSION_BUILD   = '20151207'

  # Full versioning for the current release.
  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_BUILD}"

  # Current internal DB version (independent from migrations and framework release)
  VERSION_DB = "0.1.0"
end
