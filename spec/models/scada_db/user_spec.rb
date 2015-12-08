require 'rails_helper'

module ScadaDb
  RSpec.describe User, type: :model do
    context "[a well formed instance]" do
      subject { FactoryGirl.create(:scada_db_user) }

      it "is a valid istance" do
        expect( subject ).to be_valid
      end

      it_behaves_like( "(the existance of a method)", [
        :email, :encrypted_password, :description,
        :password, :password_confirmation,
        :confirmed_at
      ])
    end
    #-- -----------------------------------------------------------------------
    #++
  end
end
