module Tardvig
  # Container which initializes and gives you access to its tools (objects).
  # Useful when you need to do a DSL
  class Toolkit
    class << self
      # @return [Hash] your tools
      def tools
        @tools ||= {}
      end

      # Adds a new tool (object).
      #
      # If the given object has either `call` or `new` methods then result of
      # the method execution will be used as a tool instead. When the `call`
      # method of your tool is executed, the toolkit will be given as the first
      # argument and the `params` (see {#initialize}) as the second.
      # @param name [Symbol] you can access your tool via this method name
      # @param tool_itself [#call, #new, Object] your tool.
      def tool(name, tool_itself = nil)
        tools[name] = tool_itself || Proc.new
      end
    end

    # Creates a new toolbox instance and initializes its tools.
    # @param params [Hash] it will be available as the second argument passed to
    #   the `call` methods of your tools.
    def initialize(params = {})
      @params = params
      create_tools_readers
    end

    private

    def tool_initialize(tool)
      if tool.respond_to? :call
        tool.call self, @params
      elsif tool.respond_to? :new
        tool.new
      else
        tool
      end
    end

    def create_tools_readers
      self.class.tools.each do |name, tool|
        instance_variable_set "@#{name}", tool_initialize(tool)
        define_singleton_method name do
          instance_variable_get "@#{name}"
        end
      end
    end
  end
end
