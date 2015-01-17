module RBFS

  class File
    attr_reader :data_type, :data

    def initialize(data=nil)
      self.data = data
    end

    def data=(value)
      @data = value
      determine_type(value)
    end

    def serialize
      "#{@data_type}:#{@data}"
    end

    def self.parse(string_data)
      type, data = string_data.split(':', 2)
      data = case type
             when 'number'  then parse_number(data)
             when 'symbol'  then data.to_sym
             when 'boolean' then data == 'true'
             when 'nil'     then nil
             else data
             end
      File.new(data)
    end

    private

    def determine_type(data)
      @data_type = case data
                   when Fixnum, Float         then :number
                   when TrueClass, FalseClass then :boolean
                   when String                then :string
                   when Symbol                then :symbol
                   else :nil
                   end
    end

    def self.parse_number(string_number)
      if string_number.include?('.')
        string_number.to_f
      else
        string_number.to_i
      end
    end
  end

  class Directory
    attr_reader :files, :directories

    def initialize
      @files = {}
      @directories = {}

      @serializer = proc { |entity_name, _| single_serialization(entity_name) }
    end

    def add_file(name, file)
      @files[name] = file
    end

    def add_directory(name, directory=Directory.new)
      @directories[name] = directory
    end

    def [](name)
      if files.has_key? name
        @files[name]
      else
        @directories[name] || Directory.new
      end
    end

    def serialize
      [@files, @directories].map do |entity_store|
        "#{entity_store.size}:#{entity_store.map(&@serializer).join}"
      end.join
    end

    def self.parse(string_data)
      parsed_directory = Directory.new

      files_count, string_data = string_data.split(':', 2)
      files, string_data = basic_file_parse(files_count.to_i, string_data, File)
      files.each { |name, file| parsed_directory.add_file(name, file) }

      directories_count, string_data = string_data.split(':', 2)
      directories, _ = basic_file_parse(directories_count.to_i, string_data, Directory)
      directories.each { |name, dir| parsed_directory.add_directory(name, dir) }

      parsed_directory
    end

    private

    def single_serialization(entity_name)
      basic_serialization = self[entity_name].serialize
      "#{entity_name}:#{basic_serialization.size}:#{basic_serialization}"
    end

    def self.basic_file_parse(files_count, string_data, file_type)
      files = []

      files_count.times do
        name, data_length, string_data = string_data.split(':', 3)
        data = string_data.slice!(0..data_length.to_i - 1)
        files << [name, file_type.parse(data)]
      end

      [files, string_data]
    end
  end
end
