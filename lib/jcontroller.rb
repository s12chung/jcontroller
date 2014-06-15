require 'request_store'

require "jcontroller/version"

require 'jcontroller/jaction'
require 'jcontroller/controller_helpers'
require 'jcontroller/filter'
require 'jcontroller/view_helpers'
require 'jcontroller/engine'

module Jcontroller
  class << self
    attr_accessor :ajax
  end
end