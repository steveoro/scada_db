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


RSpec.shared_examples "(belongs_to a model with specific namespace)" do |belongs_to_name, actual_expected_class|
  it "it belongs_to :#{belongs_to_name}" do
    expect( subject.send(belongs_to_name.to_sym) ).to be_a( actual_expected_class )
  end
end
#-- ---------------------------------------------------------------------------
#++
