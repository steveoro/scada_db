require 'rails_helper'

module ScadaDb
  RSpec.describe LogMessage, type: :model do
    context "[a well formed instance]" do
      subject { FactoryGirl.create(:scada_db_log_message) }

      it "is a valid istance" do
        expect( subject ).to be_valid
      end

      it_behaves_like( "(the existance of a method)", [
        :seq, :sender, :receiver,
        :body, :device_id
      ])

      it_behaves_like( "(belongs_to a model with specific namespace)",
        :device, ScadaDb::Device
      )
    end
    #-- -----------------------------------------------------------------------
    #++
  end
end
