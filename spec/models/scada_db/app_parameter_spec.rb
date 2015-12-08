require 'rails_helper'


module ScadaDb
  RSpec.describe AppParameter, type: :model do
    context "[a well formed instance]" do
      subject { FactoryGirl.create(:scada_db_app_parameter) }

      it "is a valid istance" do
        expect( subject ).to be_valid
      end

      it_behaves_like( "(the existance of a method)", [
        :code,
        :str_1, :str_2, :str_3,
        :bool_1, :bool_2, :bool_3,
        :int_1, :int_2, :int_3,
        :description
      ])
    end
    #-- -----------------------------------------------------------------------
    #++
  end
end
