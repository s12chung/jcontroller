require 'spec_helper'

feature 'invoke correct dom route', :js => true do
  context 'without parameters' do
    def filters(controller_namespace, action)
      %W[before #{action} after].map do |filter|
        "#{controller_namespace}/html/#{filter}"
      end
    end

    def test_elements(filters)
      within '#test_append' do
        filters.zip(all('div')).each do |filter, div|
          div[:filter].should == filter
        end
      end
    end


    scenario 'with basic controller' do
      visit '/users'
      puts page.html
      test_elements filters('users', "index")
    end
  end
end