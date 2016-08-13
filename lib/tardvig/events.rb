module Tardvig
  # The mixin gives ability to have events
  # @see https://en.wikipedia.org/wiki/Event_%28computing%29
  module Events
    # Binds given listener (handler/callback) to given event name
    def on(event, &listener)
      listeners(event) << listener
    end

    # Unbinds given listener from the given event name
    def remove_listener(event, listener = nil)
      if listener.nil?
        listeners(event).clear
      else
        listeners(event).delete listener
      end
    end

    # Executes all the listeners which are bound to the given event name
    # @param data [Object] the object will be passed as an argument to the
    #   listeners
    def happen(event, data = nil)
      listeners(event).clone.each do |listener|
        listener.call(data)
      end
    end

    alias trigger happen

    # @return [Array] array with all the listeners which are bound to the given
    #   event name
    def listeners(event)
      @listeners ||= {}
      @listeners[event] ||= []
    end
  end
end
