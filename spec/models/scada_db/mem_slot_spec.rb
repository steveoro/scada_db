require 'rails_helper'

module ScadaDb
  RSpec.describe MemSlot, type: :model do
    context "[a well formed instance]" do
      subject { FactoryGirl.create(:scada_db_mem_slot) }

      it "is a valid istance" do
        expect( subject ).to be_valid
      end

      it_behaves_like( "(the existance of a method)", [
        :msw, :lsw, :format,
        :device_id,
        :description, :unit, :decimals,
        :notes
      ])

      it_behaves_like( "(belongs_to a model with specific namespace)",
        :device, ScadaDb::Device
      )
    end
    #-- -----------------------------------------------------------------------
    #++
  end
end
