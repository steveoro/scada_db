require 'ffaker'


FactoryGirl.define do

  factory :scada_db_mem_slot, class: ScadaDb::MemSlot do
    msw           { FFaker.hexify('####') }
    lsw           { FFaker.hexify('####') }
    format        "1W"
    device        { FactoryGirl.create(:scada_db_device) }
    description   { "#{ device.name } #{FFaker::Lorem.word} sensor" }
    unit          { ["°C", "°K", "N/mt^2", "Kg", "msec.", "sec.", "mt."].sort{ rand - 0.5 }[0] }
  end
  #-- -------------------------------------------------------------------------
  #++
end
