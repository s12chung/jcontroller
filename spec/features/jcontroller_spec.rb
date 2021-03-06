require 'spec_helper'

feature 'invoke correct filter', :js => true do
  before :all do
    @test_append_selector = '#test_append'
  end

  def filter_namespace(controller_namespace, filter, format="html")
    "#{controller_namespace}/#{format}/#{filter}"
  end

  def filters(controller_namespace, action, options={})
    options = options.reverse_merge({ :parent_namespaces => %w[application], :format => "html" })

    controller_namespaces = options[:parent_namespaces] + [controller_namespace]
    filters = []
    filters += controller_namespaces.map {|controller_namespace| filter_namespace(controller_namespace, "before", options[:format]) }
    filters += controller_namespaces.map {|controller_namespace| filter_namespace(controller_namespace, action, options[:format]) }
    filters + controller_namespaces.map {|controller_namespace| filter_namespace(controller_namespace, "after", options[:format]) }.reverse
  end

  def test_elements(filters, parameters="")
    if parameters.class == String; parameters = [parameters] * filters.size end
    within @test_append_selector do
      (0..filters.size-1).zip(all('div')).each do |index, div|
        div[:filter].should == filters[index]
        div.text.should == parameters[index]
      end
    end
  end

  def test_no_elements
    within @test_append_selector do
      all('div').size.should == 0
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
    test_elements filters('superusers', "index", { :parent_namespaces => %w[application users]})
  end
  scenario 'with empty parent controller' do
    visit empty_parents_path
    test_elements filters('empty_parents', "index")
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
    test_no_elements
  end
  scenario "when redirected" do
    visit redirect_users_path
    redirect_filters = filters('users', "redirect")
    index_filters = filters('users', "index")
    test_elements redirect_filters + index_filters, ["redirect template"] * redirect_filters.size + [""] * redirect_filters.size
  end
  scenario "when redirected with parameters template" do
    visit redirect_simple_users_path
    redirect_filters = filters('users', "redirect_simple")
    index_filters = filters('users', "index")
    test_elements redirect_filters + index_filters, ["redirect parameters"] * redirect_filters.size + [""] * redirect_filters.size
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
    test_elements filters('users', "parameters_template"), "parameter template html_params"
  end

  context "with ajax" do
    before :each do
      Jcontroller.ajax = true
    end
    after :each do
      Jcontroller.ajax = nil
    end

    scenario "ajax off" do
      Jcontroller.ajax = nil
      visit stopped_users_path
      click_link "ajax link"
      wait_for_ajax
      test_no_elements
    end

    scenario "basic controller" do
      visit stopped_users_path
      click_link "ajax link"
      wait_for_ajax
      test_elements filters('users', "index", { :format => "js"}), "ajax parameter"
    end

    scenario "with _params template existing" do
      visit parameters_template_users_path
      click_link "ajax link"
      wait_for_ajax
      test_elements filters('users', "parameters_template", { :format => "js"}), "parameter template js"
    end
  end
end