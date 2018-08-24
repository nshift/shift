module Shift
  module BuiltIn

    class GuidelineUnknownCommand < StandardError
    end

    Dir[File.expand_path('*.rb', File.dirname(__FILE__) + "/guideline")].each do |file|
      require file
    end

    class Guideline

      def self.guideline_class_ref(guideline_name)
        class_name = "BuiltIn::Guideline::#{guideline_name.shift_class}"
        begin
          return Shift.const_get(class_name)
        rescue NameError
          return nil
        end
      end

      def self.name
        return File.basename(__FILE__, File.extname(__FILE__))
      end

      def self.execute(arguments)
        return false unless action = arguments[0]
        return false unless guideline_name = arguments[1].to_s
        return false unless ref = Guideline.guideline_class_ref(guideline_name)
        case action
          when :validate
            return ref.validate(arguments)
          else
            raise GuidelineUnknownCommand, "#{arguments[0]} is a unknown action."
        end
      end
    end
  end
end