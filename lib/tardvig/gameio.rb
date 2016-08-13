module Tardvig
  # Interface which represents a connection to something that will display your
  # game (I will call something that will display your game "display").
  # Every display has its GameIO so if your game has a server and many people
  # connected then you will have many GameIO instances.
  #
  # Communication should be realized via events.
  # @abstract
  class GameIO
    include Events
  end
end
