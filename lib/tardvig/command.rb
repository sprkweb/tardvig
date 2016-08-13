module Tardvig
  # @abstract The class represents abstract algorithm.
  #   It is something like Proc, but your code is stored in the class instead of
  #   object so you can use instance variables and divide your code into
  #   methods.
  #
  #   See the `spec` directory for example.
  class Command
    # @param params [Hash] these key => value pairs will be instance variables
    #  with reader methods
    def initialize(params = {})
      handle_params(params)
    end

    # Executes your process (you should redefine the `process` method)
    # @param (see #initialize)
    # @return [Command] self
    def call(params = {})
      handle_params(params)
      execute
      self
    end

    # Creates a new instance and executes it.
    # @param (see #call)
    # @return self
    def self.call(params = {})
      new.call(params)
    end

    private

    # The method is used for be redefined in the situation when you need to
    # change the execution order. By default it executes `process` only.
    # See the specs for example.
    # @!visibility public
    def execute
      process
    end

    # @abstract Redefine this method and it will do whatever you want whilst
    #   execution
    # @!visibility public
    def process
      raise NoMethodError, 'You should define #process for your Command'
    end

    def handle_params(params)
      params.each_pair do |name, value|
        var_name = :"@#{name}"
        instance_variable_set var_name, value
        define_singleton_method name do
          instance_variable_get var_name
        end
      end
    end
  end
end
