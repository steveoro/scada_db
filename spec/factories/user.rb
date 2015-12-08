require 'ffaker'
require "digest/sha1"
require 'securerandom'


FactoryGirl.define do

  factory :scada_db_user, class: ScadaDb::User do
    description           { "#{FFaker::Name.first_name} #{FFaker::Name.last_name}" }
                          # Let's use a huge trailing number to avoid duplicate emails:
    email                 { FFaker::Internet.safe_email("#{description} #{SecureRandom.urlsafe_base64(8)}") }
    password              "password"
    password_confirmation "password"
    confirmed_at          { DateTime.now }
    created_at            { DateTime.now }
    updated_at            { DateTime.now }
  end
  #-- -------------------------------------------------------------------------
  #++
end
