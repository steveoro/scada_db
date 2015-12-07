require 'ffaker'


FactoryGirl.define do

  factory :scada_db_device, class: ScadaDb::Device do
    name          { FFaker::Product.model }
    description   { FFaker::Product.product }

    after(:build) do |built_instance|
      while built_instance.invalid?
        puts "\r\n(Re-)building device instance to avoid invalid unique name in ScadaDb::Device factory..."
        built_instance.name = FFaker::Product.model
      end
    end
  end
  #-- -------------------------------------------------------------------------
  #++
end
