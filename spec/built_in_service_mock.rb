class BuiltInServiceMock
  attr_accessor :history

  def initialize
    @history ||= []
  end

  def loadDefaultBuiltIns

  end

  def can_be_executed?(built_in_name)
    return built_in_name == "__test"
  end

  def execute(built_in_name, arguments)
    executed = can_be_executed?(built_in_name)
    return false if executed == false
    @history.push("#{built_in_name} #{arguments.first}")
    return true
  end
end