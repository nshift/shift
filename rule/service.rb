module Shift

  class RuleCommandError < StandardError
  end

  class RuleCommandNotFound < StandardError
  end

  class RuleNotFound < StandardError
  end

  class RuleError < StandardError
  end

  class RuleWarning < StandardError
  end

  class RuleService
    
    def initialize(rules = [])
      @rules = rules
    end

    def can_be_executed?(method_name)
      return method_name == "rule"
    end

    def execute(method_name, arguments)
      raise RuleCommandError, "#{method_name} is not a command rule." if !can_be_executed?(method_name)
      raise RuleCommandNotFound, "#{arguments.first} rule does not exist." unless block = @rules[arguments.first]
      
      rule_name = arguments[0]
      status = arguments[1]
      validation = arguments[2].nil? ? true : arguments[2].validate?
      result = false
      
      return false if validation == false
      begin
        result = block.call
      rescue CommandFailed => commandFailed
        raise RuleWarning, commandFailed.message if validation == true && status == :warning
        raise RuleError, commandFailed.message if validation == true && status == :error
      rescue => e
        raise e
      else
        if result == false
          error_message = "Unknown error occured while executing `#{rule_name}` rule command."
          raise RuleWarning, error_message if validation == true && status == :warning
          raise RuleError, error_message if validation == true && status == :error
        end
        return result
      end
    end
  end
end