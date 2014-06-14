require 'spec_helper'

feature 'invoke correct filter', :js => true do
  before :all do
    @test_append_selector = '#test_append'
  end

  def filter_namespace(controller_namespace, filter, format="html")
    "#{controller_namespace}/#{format}/#{filter}"
  end

  def filters(controller_namespace, action, parent_namespaces=%w[application])
    controller_namespaces = parent_namespaces + [controller_namespace]
    filters = []
    filters += controller_namespaces.map {|controller_namespace| filter_namespace(controller_namespace, "before") }
    filters += controller_namespaces.map {|controller_namespace| filter_namespace(controller_namespace, action) }
    filters + controller_namespaces.map {|controller_namespace| filter_namespace(controller_namespace, "after") }.reverse
  end

  def test_elements(filters, parameter=nil)
    within @test_append_selector do
      filters.zip(all('div')).each do |filter, div|
        div[:filter].should == filter
        div.text.should == (parameter ? parameter : "")
      end
    end
  end

  it "should pass the state of the request" do
    visit state_users_path
    find(@test_append_selector).text.should == {
        controller_path: "users",
        action_name: "state",
        method: "GET",
        path: "/users/state",
        format: "html",
        jaction: {
            controller_path: "users",
            action_name: "state",
            format: "html"
        }
    }.to_json
  end

  scenario 'with basic controller' do
    visit users_path
    test_elements filters('users', "index")
  end
  scenario 'with namespaced controller' do
    visit admin_users_path
    test_elements filters('admin/users', "index")
  end
  scenario 'with superclassed controller' do
    visit superusers_path
    test_elements filters('superusers', "index", %w[application users])
  end

  scenario 'with no action defined' do
    visit no_action_users_path
    test_elements filters('users', "no_action").delete_if {|namespace| namespace.rindex "no_action" }
  end

  scenario "with manual execution" do
    visit manually_execute_users_path
    test_elements (filters('users', "index") + filters('users', 'manually_execute'))
  end

  scenario "when stopped" do
    visit stopped_users_path
    within @test_append_selector do
      all('div').size.should == 0
    end
  end
  scenario "with different action" do
    visit different_action_users_path
    test_elements filters('users', "index")
  end
  scenario 'with parameters' do
    visit manual_parameters_users_path
    test_elements filters('users', "manual_parameters"), "manual parameters"
  end
  scenario "with different action and parameters" do
    visit action_and_parameters_users_path
    test_elements filters('users', "index"), "action and manual parameters"
  end
  scenario 'with parameters template' do
    visit parameters_template_users_path
    test_elements filters('users', "parameters_template"), "parameter template"
  end

  context "with ajax" do
    scenario "basic controller" do
      visit stopped_users_path
      click_link "ajax link"
      test_elements filters('users', "index"), "ajax parameter"
    end
  end
end