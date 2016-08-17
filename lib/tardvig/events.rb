module Tardvig
  # The mixin gives ability to have events
  # @see https://en.wikipedia.org/wiki/Event_%28computing%29
  module Events
    # Binds given listener (handler/callback) to given event name
    # @param event [Object] any custom identificator. Your listener will be
    #   executed only when you trigger event with this identificator.
    # @param listener [#call] this object will be executed (through the #call
    #   method) when you trigger the given event.
    def on(event, &listener)
      listeners(event) << listener
    end

    # Does the same as {#on}, but the listener will be executed only once, then
    # it will be deleted.
    # @param (see #on)
    def on_first(event, &listener)
      throwaway_callback = proc do |*args|
        remove_listener event, throwaway_callback
        listener.call(*args)
      end
      listeners(event) << throwaway_callback
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
