module Tardvig
  # @abstract Represents the abstract part of your game.
  #   It may be anything, depends on your realization: level, location,
  #   cut-scene, credits, etc.
  class Act < Command
    class << self
      # @overload act_type(type)
      #   @param type [String, Symbol] set your custom act type. This is needed
      #     for your display to differ acts and correspondingly intepret them.
      # @overload act_type
      #   @return type of your act
      def act_type(type = nil)
        if type
          @type = type
        elsif @type
          @type
        elsif superclass.respond_to? :act_type
          superclass.act_type
        end
      end

      # @overload subject(value)
      #   If there was MVC, I would
      #   say act is a model, subject is its data and other part of act is
      #   business logic.
      #   But there is no MVC, so *subject is the content of
      #   your act and the methods of the act should process it*.
      #
      #   For example, if your act is a location of FPS, subject is the location
      #   file and methods of your act should control player's enemies. If act
      #   is a cut-scene, subject is the video file (probably name of the file).
      #   @param value [Object] subject of your act.
      # @overload subject
      #   @return [Object] subject of your act
      def subject(value = nil)
        if value
          @subject = value
        else
          @subject
        end
      end
    end

    private

    def process
    end

    def execute
      notify_display
      process
    end

    # This method notifies your display via GameIO when the act is executed.
    # You can redefine it if you want to send another message or do not want to
    # send anything.
    # @!visibility public
    def notify_display
      io.happen :act_start, type: self.class.act_type, subject: display_format
    end

    # This method should return the object which will be sent to the display.
    # By default it returns the subject. But you can redefine it.
    # @!visibility public
    def display_format
      self.class.subject
    end
  end
end
