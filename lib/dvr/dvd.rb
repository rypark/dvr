module DVR
  class Dvd

    attr_accessor :name

    def initialize(name, options)
      @name = name
    end

    def eject
      # Save response to json file if it doesn't exist
    end

    def file
      DVR.configuration.dvd_library_dir + '/' + @name
    end

  end
end
