require 'rails_helper'

module ScadaDb
  RSpec.describe Device, type: :model do
    context "[a well formed instance]" do
      subject { FactoryGirl.create(:scada_db_device) }

      it "is a valid istance" do
        expect( subject ).to be_valid
      end

      it_behaves_like( "(the existance of a method)", [
        :name, :description, :notes
      ])
    end
    #-- -----------------------------------------------------------------------
    #++
  end
end
