module DVR
  class Dvd

    attr_accessor :name

    def initialize(name, options = {})
      @name = name
    end

    def persisted?
      File.exist?(file_path)
    end

    def save_to_file(body)
      puts "Saving file to: #{file_path}"
      File.open(file_path, 'w') { |f| f.write(body) }
    end

    def body
      return if !persisted?
      File.read(file_path)
    end

    def file_path
      DVR.configuration.dvd_library_dir + '/' + @name + '.json'
    end

  end
end
