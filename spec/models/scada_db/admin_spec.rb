require 'rails_helper'

module ScadaDb
  RSpec.describe Admin, type: :model do
    context "[a well formed instance]" do
      subject { FactoryGirl.create(:scada_db_admin) }

      it "is a valid istance" do
        expect( subject ).to be_valid
      end

      it_behaves_like( "(the existance of a method)", [
        :email, :encrypted_password, :description,
        :password, :password_confirmation
      ])
    end
    #-- -----------------------------------------------------------------------
    #++
  end
end
