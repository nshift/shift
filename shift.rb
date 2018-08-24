module Shift
  class CommandFailed < StandardError
  end
  
  class ShiftError < StandardError
    attr_accessor :error

    def initialize(error)
      error[:severity] = :error if ! error.key?(:severity)
      @error = error
      super(error[:message])
    end
  end
  
  class ShiftErrors < StandardError
    attr_accessor :errors

    def initialize(errors = [])
      errors.each { |error| error[:severity] = :error if ! error.key?(:severity) }
      @errors = errors
      super(errors.map { |error| error[:message] }.join('\n'))
    end
  end
end

require_relative "string"
require_relative "built_in/service"
require_relative "filter/service"
require_relative "rule/service"
require_relative "shift_file/service"
require_relative "lane/service"

module Shift
  class ShiftCore
    
    def initialize(
      built_in_service = BuiltInService.new,
      filter_service = FilterService.new,
      shift_file_service = ShiftFileService.new(self),
      lane_service = LaneService.new
    )
      @built_in_service = built_in_service
      @filter_service = filter_service
      @rule_service = nil
      @shift_file_service = shift_file_service
      @lane_service = lane_service
      @rule_service = RuleService.new
    end

    def execute_lane(lane_name, folder = Shift::ShiftFolder.new)
      shift_file = @shift_file_service.read(folder)
      @rule_service = RuleService.new(shift_file[:rules])
      @lane_service.execute_lane(lane_name, shift_file)
    end

    def execute_lanes(folder = Shift::ShiftFolder.new)
      shift_file = @shift_file_service.read(folder)
      @rule_service = RuleService.new(shift_file[:rules])
      @lane_service.execute_lanes(shift_file)
    end

    def respond_to_missing?(method_sym, private = false)
      return (@built_in_service.can_be_executed?(method_sym.to_s) || 
        @rule_service.can_be_executed?(method_sym.to_s) || 
        @filter_service.can_be_executed?(method_sym.to_s))
    end
    
    def method_missing(method_sym, *arguments, &_block)
      return super if respond_to_missing?(method_sym) == false
      begin
        return @filter_service.filter(method_sym.to_s, arguments) if @filter_service.can_be_executed?(method_sym.to_s) == true
        return execute_rule(method_sym.to_s, arguments) if @rule_service.can_be_executed?(method_sym.to_s) == true
        return @built_in_service.execute(method_sym.to_s, arguments) if @built_in_service.can_be_executed?(method_sym.to_s) == true
        return super
      rescue Shift::ShiftError => shift_error
        display_error(shift_error.error)
        raise shift_error if shift_error.error[:severity] == :error
      rescue Shift::ShiftErrors => shift_errors
        shift_errors.errors.each { |error| display_error(error) }
        raise shift_errors if shift_errors.errors.any? { |error| error[:severity] == :error }
      rescue => e
        raise e
      end
    end

    private

    attr_accessor :built_in_service, :filter_service, :rule_service, :shift_file_service, :lane_service

    def execute_rule(method_sym, arguments)
      begin
        return @rule_service.execute(method_sym, arguments) 
      rescue Shift::RuleWarning => warning
        puts "⚠️  Warning: #{warning.message}"
      rescue Shift::RuleError => error
        puts "💥 Error: #{error.message}"
        raise error
      rescue => e
        raise e
      end
      return nil
    end

    def display_error(error)
      case error[:severity]
        when :error
          puts "💥 Error: #{error[:message]}"
        when :warning
          puts "⚠️  Warning: #{error[:message]}"
      end
    end
  end
end