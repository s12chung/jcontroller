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
      if controller_path || action_name
        @target_jaction.controller_path.should == controller_path
        @target_jaction.action_name.should == action_name
      else
        @target_jaction.controller_path.should == 0
        @target_jaction.action_name.should == 1
        @target_jaction.format.should == :js
        @target_jaction.params.should == {}
      end
    end

    it "should take the passed Action's attributes" do
      @jaction.controller_path = 0
      @jaction.action_name = 1
      @jaction.format = :js
      @jaction.params = {}
      @target_jaction.parse(@jaction)
      test_values
    end

    it "should take a hash" do
      @target_jaction.parse(:controller_path => 0, :action_name => 1, :format => :js, :params => {})
      test_values
    end

    it "should take just an action" do
      @target_jaction.parse("index")
      test_values nil, "index"
    end

    it "should take a # string" do
      @target_jaction.parse("users#index")
      test_values "users", "index"
    end

    it "should take a namespaced / string with a format and parameters" do
      @target_jaction.parse("admin/users/index.js?blah=meh&waka=baka")
      test_values "admin/users", "index"
      @target_jaction.format.should == :js
      @target_jaction.params[:blah].should == "meh"
      @target_jaction.params[:waka].should == "baka"
    end
  end
end