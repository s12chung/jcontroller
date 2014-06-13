require 'spec_helper'

feature 'invoke correct dom route', :js => true do
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

  def test_elements(filters)
    within '#test_append' do
      filters.zip(all('div')).each do |filter, div|
        div[:filter].should == filter
      end
    end
  end


  scenario 'with basic controller' do
    visit users_path
    test_elements filters('users', "index")
  end

  scenario 'with no action defined' do
    visit no_action_users_path
    within '#test_append' do
      all('div').size.should == 0
    end
  end
end