require 'rails_helper'


RSpec.shared_examples "(the existance of a class method)" do |method_name_array|
  method_name_array.each do |method_name|
    it "responds to ##{method_name}" do
      expect( subject.class ).to respond_to( method_name )
    end
  end
end


RSpec.shared_examples "(the existance of a method)" do |method_name_array|
  method_name_array.each do |method_name|
    it "responds to ##{method_name}" do
      expect( subject ).to respond_to( method_name )
    end
  end
end
#-- ---------------------------------------------------------------------------
#++


RSpec.shared_examples "(the existance of a method returning a valid instance)" do |method_name, instance_const|
  describe "##{method_name}" do
    it "responds to ##{method_name}" do
      expect( subject ).to respond_to( method_name )
    end
    it "returns an instance of #{instance_const}" do
      expect( subject.send(method_name) ).to be_an_instance_of( instance_const )
    end
    it "returns a valid instance" do
      expect( subject.send(method_name) ).to be_valid
    end
  end
end


RSpec.shared_examples "(the existance of a method with parameter returning a valid instance or nil)" do |method_name, instance_const, parameter|
  describe "##{method_name}" do
    it "responds to ##{method_name}" do
      expect( subject ).to respond_to( method_name )
    end
    it "returns an instance of #{instance_const}" do
      expect( subject.send(method_name, parameter) ).to be_an_instance_of( instance_const ).or be_nil
    end
  end
end
#-- ---------------------------------------------------------------------------
#++


RSpec.shared_examples "(the existance of a method returning strings)" do |method_name_array|
  it_behaves_like "(the existance of a method)", method_name_array
  method_name_array.each do |method_name|
    it "##{method_name} returns a String" do
      expect( subject.send(method_name.to_sym) ).to be_an_instance_of( String )
    end
  end
end


RSpec.shared_examples "(the existance of a method returning non-empty strings)" do |method_name_array|
  it_behaves_like "(the existance of a method returning strings)", method_name_array
  method_name_array.each do |method_name|
    it "##{method_name} returns a non empty string" do
      expect( subject.send(method_name.to_sym) ).not_to eq( '' )
    end
  end
end
#-- ---------------------------------------------------------------------------
#++


RSpec.shared_examples "(the existance of a method returning a non-empty Hash)" do |method_name_array|
  it_behaves_like "(the existance of a method)", method_name_array
  method_name_array.each do |method_name|
    it "##{method_name} returns a non empty Hash" do
      result = subject.send(method_name.to_sym)
      expect( result ).to be_an_instance_of( Hash )
      expect( result.keys ).to be_an_instance_of( Array )
      expect( result.keys.size ).to be > 0
      expect( result.values ).to be_an_instance_of( Array )
      expect( result.values.size ).to be > 0
    end
  end
end


RSpec.shared_examples "(the existance of a method returning a boolean value)" do |method_name_array|
  it_behaves_like "(the existance of a method)", method_name_array
  method_name_array.each do |method_name|
    it "##{method_name} returns a boolean" do
      result = subject.send(method_name.to_sym)
      if result
        expect( result == true ).to be true
      else
        expect( result == false ).to be true
      end
    end
  end
end



RSpec.shared_examples "(the existance of a method returning numeric values)" do |method_name_array|
  it_behaves_like "(the existance of a method)", method_name_array
  method_name_array.each do |method_name|
    it "##{method_name} returns a numeric value" do
      expect( subject.send(method_name.to_sym) ).to be_a_kind_of( Numeric ).or be_a_kind_of( BigDecimal )
    end
  end
end
#-- ---------------------------------------------------------------------------
#++


RSpec.shared_examples "(the existance of a method with parameters, returning String or nil)" do |method_name_array, parameter|
  it_behaves_like "(the existance of a method)", method_name_array
  method_name_array.each do |method_name|
    it "##{method_name} returns a String value or nil" do
      result = subject.send(method_name.to_sym, parameter)
      if result
        expect( result ).to be_an_instance_of( String )
      else
        expect( result ).to be_nil
      end
    end
  end
end


RSpec.shared_examples "(the existance of a method with parameters, returning boolean values)" do |method_name_array, parameter|
  it_behaves_like( "(the existance of a method)", method_name_array )
  method_name_array.each do |method_name|
    it "##{method_name} returns a boolean value" do
      result = subject.send(method_name.to_sym, parameter)
      if result
        expect( result == true ).to be true
      else
        expect( result == false ).to be true
      end
    end
  end
end


RSpec.shared_examples "(the existance of a method with parameters, returning numeric values)" do |method_name_array, parameter|
  it_behaves_like "(the existance of a method)", method_name_array
  method_name_array.each do |method_name|
    it "##{method_name} returns a numeric value" do
      expect( subject.send(method_name.to_sym, parameter) ).to be_a_kind_of( Numeric ).or be_a_kind_of( BigDecimal )
    end
  end
end
#-- ---------------------------------------------------------------------------
#++


RSpec.shared_examples "(the existance of a method returning a collection or an object responding to :each and :count)" do |method_name_array|
  it_behaves_like "(the existance of a method)", method_name_array
  method_name_array.each do |method_name|
    describe "##{method_name}" do
      it "returns a collection responding to :each" do
        expect( subject.send(method_name.to_sym) ).to respond_to(:each)
      end
      it "returns a collection responding to :count" do
        expect( subject.send(method_name.to_sym) ).to respond_to(:count)
      end
    end
  end
end


RSpec.shared_examples "(the existance of a method returning a collection of some kind of instances)" do |method_name_array, common_kind|
  it_behaves_like "(the existance of a method returning an array)", method_name_array
  method_name_array.each do |method_name|
    describe "##{method_name}" do
      it "returns a collection responding to :each" do
        expect( subject.send(method_name.to_sym) ).to respond_to(:each)
      end
      it "returns a collection responding to :count" do
        expect( subject.send(method_name.to_sym) ).to respond_to(:count)
      end
      it "returns a list of #{common_kind.name}" do
        subject.send(method_name.to_sym).each do |element|
          expect( element ).to be_a_kind_of( common_kind )
        end
      end
    end
  end
end
#-- ---------------------------------------------------------------------------
#++

