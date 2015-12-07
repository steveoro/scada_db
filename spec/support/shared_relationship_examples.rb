require 'rails_helper'


RSpec.shared_examples "(it has_one of these required models)" do |attribute_name_array|
  attribute_name_array.each do |attribute_name|
    it "responds to :#{attribute_name}" do
      expect( subject ).to respond_to( attribute_name )
    end
    it "returns an instance of #{attribute_name.to_s.camelize}" do
      expect( subject.send(attribute_name) ).to be_an_instance_of( attribute_name.to_s.camelize.constantize )
    end
  end
end


RSpec.shared_examples "(belongs_to required models)" do |attribute_name_array|
  attribute_name_array.each do |attribute_name|
    it "it belongs_to :#{attribute_name}" do
      expect( subject.send(attribute_name.to_sym) ).to be_a( eval(attribute_name.to_s.camelize) )
    end
  end
end
#-- ---------------------------------------------------------------------------
#++
