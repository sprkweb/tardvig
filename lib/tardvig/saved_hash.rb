module Tardvig
  # This is a hash which can be saved to a file (via YAML). It also has some
  # events.
  #
  # It is useful for progress saving, configuration and settings files,
  # localization files and many other things.
  #
  # Events:
  # * `save` happen before saving data to a file. Arguments: the hash itself
  # * `load` happen after loading data from a file. Arguments: the hash itself
  class SavedHash < Hash
    include Events

    def initialize(io = nil)
      load io unless io.nil?
    end

    # Save the hash to the file through YAML
    # @param io [IO, String] the IO instance or the name of the file.
    #   The data will be saved here.
    def save(io)
      open_file io, 'w' do |f|
        trigger :save, self
        f.write YAML.dump(self)
      end
    end

    # Loads the data from the YAML file to itself. If there are old data in the
    # hash, it overrides them.
    # @param io [IO, String] the IO instance or the name of the file.
    #   The data will be loaded from here.
    def load(io)
      open_file io, 'r' do |f|
        merge! YAML.load(f.read)
        trigger :load, self
      end
    end

    private

    def open_file(io, mode)
      if io.respond_to?(:read) && io.respond_to?(:write)
        yield io
      elsif io.is_a? String
        File.open(io, mode) { |f| yield f }
      else
        raise ArgumentError
      end
    end
  end
end
