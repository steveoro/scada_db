require 'ffaker'


FactoryGirl.define do

  factory :scada_db_log_request, class: ScadaDb::LogRequest do
    sequence( :seq )
    device            { FactoryGirl.create(:scada_db_device) }
    sender            { device.name }
    receiver          { FFaker::Product.model }
    body              { "ACK #{ receiver }..." }
  end
  #-- -------------------------------------------------------------------------
  #++
end
