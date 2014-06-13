require 'spec_helper'

describe Jcontroller::Action do
  describe '#parse' do
    before :each do
      @target_action = Jcontroller::Action.new
      @action = Jcontroller::Action.new
    end

    it "should start with nil attributes if there is no controller" do
      Jcontroller::Action::ATTRIBUTES.each do |attribute|
        @target_action.send(attribute).should == nil
      end
    end

    def test_values(controller_path=nil, action_name=nil)
      if controller_path
        @target_action.controller_path.should == controller_path
        @target_action.action_name.should == action_name
      else
        Jcontroller::Action::ATTRIBUTES.each_with_index do |attribute, index|
          @target_action.send(attribute).should == index
        end
      end
    end

    it "should take the passed Action's attributes" do
      Jcontroller::Action::ATTRIBUTES.each_with_index do |attribute, index|
        @action.send(attribute + "=", index)
      end
      @target_action.parse(@action)
      test_values
    end

    it "should take a hash" do
      @target_action.parse(controller_path: 0, action_name: 1, format: 2)
      test_values
    end

    it "should take a # string" do
      @target_action.parse("users#index")
      test_values "users", "index"
    end

    it "should take a / string" do
      @target_action.parse("users/index")
      test_values "users", "index"

    end

    it "should take a namespaced path string" do
      @target_action.parse("admin/users/index")
      test_values "admin/users", "index"
    end
  end
end