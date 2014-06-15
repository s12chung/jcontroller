$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f}

require 'fake_app/fake_app'
require 'rspec/rails'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist