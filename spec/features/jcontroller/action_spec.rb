require 'spec_helper'

describe Jcontroller::Jaction do
  describe '#parse' do
    before :each do
      @target_jaction = Jcontroller::Jaction.new
      @jaction = Jcontroller::Jaction.new
    end

    it "should start with empty attributes if there is no controller" do
      Jcontroller::Jaction::ATTRIBUTES.each do |attribute|
        @target_jaction.send(attribute).should == (attribute == "params" ? {} : nil)
      end
    end

    def test_values(controller_path=nil, action_name=nil)
      if controller_path
        @target_jaction.controller_path.should == controller_path
        @target_jaction.action_name.should == action_name
      else
        Jcontroller::Jaction::ATTRIBUTES.each_with_index do |attribute, index|
          @target_jaction.send(attribute).should == index
        end
      end
    end

    it "should take the passed Action's attributes" do
      Jcontroller::Jaction::ATTRIBUTES.each_with_index do |attribute, index|
        @jaction.send(attribute + "=", index)
      end
      @target_jaction.parse(@jaction)
      test_values
    end

    it "should take a hash" do
      @target_jaction.parse(:controller_path => 0, :action_name => 1, :format => 2, :params => 3)
      test_values
    end

    it "should take a # string" do
      @target_jaction.parse("users#index")
      test_values "users", "index"
    end

    it "should take a / string" do
      @target_jaction.parse("users/index")
      test_values "users", "index"

    end

    it "should take a namespaced path string" do
      @target_jaction.parse("admin/users/index")
      test_values "admin/users", "index"
    end
  end
end