module Shift
  class FilterService
    def initialize
      loadDefaultFilters
    end

    def loadDefaultFilters
      Dir[File.expand_path('*.rb', File.dirname(__FILE__))].each do |file|
        require file
      end
    end

    def can_be_executed?(filter_name)
      return FilterService.filter_class_ref?(filter_name)
    end

    def filter(filter_name, arguments)
      return FilterService.filter_class_ref(filter_name, arguments)
    end

    def self.filter_class_ref?(filter_name)
      class_name = "Filter::" + filter_name.capitalize
      begin
        return !Shift.const_get(class_name).nil?
      rescue
        return false
      end
    end

    def self.filter_class_ref(filter_name, arguments)
      class_name = "Filter::" + filter_name.capitalize
      begin
        return Shift.const_get(class_name).new(arguments)
      rescue NameError
        return nil
      end
    end
  end
end