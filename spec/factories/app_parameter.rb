require 'ffaker'


FactoryGirl.define do

  factory :scada_db_app_parameter, class: ScadaDb::AppParameter do
    sequence( :code )
    str_1         { FFaker::Lorem.word }
    description   "A random word in str_1"
  end
  #-- -------------------------------------------------------------------------
  #++
end
