module Shift

  class BuiltInFailed < CommandFailed
  end

  class BuiltInService
    def initialize
      loadDefaultBuiltIns
    end
    
    def loadDefaultBuiltIns
      Dir[File.expand_path('*.rb', File.dirname(__FILE__))].each do |file|
        require file
      end
    end

    def can_be_executed?(built_in_name)
      return BuiltInService.built_in_class_ref(built_in_name) != nil
    end

    def execute(built_in_name, arguments)
      return false unless ref = BuiltInService.built_in_class_ref(built_in_name)
      return ref.execute(arguments)
    end

    def self.built_in_class_ref(built_in_name)
      class_name = "BuiltIn::" + built_in_name.shift_class
      begin
        return Shift.const_get(class_name)
      rescue NameError
        return nil
      end
    end
  end
end