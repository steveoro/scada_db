require 'ffaker'


FactoryGirl.define do

  factory :scada_db_log_message, class: ScadaDb::LogMessage do
    sequence( :seq )
    device            { FactoryGirl.create(:scada_db_device) }
    sender            { device.name }
    receiver          { FFaker::Product.model }
    body              { "PING #{ receiver }..." }
  end
  #-- -------------------------------------------------------------------------
  #++
end
