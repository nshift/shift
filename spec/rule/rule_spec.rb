require_relative "../../shift"

mock_folder_name = "./spec/rule/mock"

describe Shift::ShiftCore, "a user want to execute a rule called :swift4_support" do
  context ":swift4_support rule does not exist" do
    it "should not execute beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "swift4_support_rule_not_found")

      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::RuleCommandNotFound
    end
  end
  context ":swift4_support error rule failed" do
    it "should raise an exception that describes an error" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "swift4_support_rule_failed_error")

      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::RuleError
    end
  end
  context ":swift4_support warning rule failed" do
    it "should display a message that describes a warning" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "swift4_support_rule_failed_warning")

      expect { core.execute_lane(:beta, folder) }.not_to raise_error
    end
  end
  context ":swift4_support error rule contains not found commands" do
    it "should raise an exception that describes a rule error" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "swift4_support_rule_command_not_found_error")

      expect { core.execute_lane(:beta, folder) }.to raise_error NameError
    end
  end
  context ":swift4_support warning rule contains not found commands" do
    it "should raise an exception that describes a rule error" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "swift4_support_rule_command_not_found_warning")

      expect { core.execute_lane(:beta, folder) }.to raise_error NameError
    end
  end
  context ":swift4_support error rule contains failed command" do
    it "should raise an exception that describes a rule error" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "swift4_support_rule_command_failed_error")

      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::RuleError
    end
  end
  context ":swift4_support rule exist" do
    it "should execute the :swift4_support rule" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "swift4_support_rule_success")

      expect { core.execute_lanes(folder) }.not_to raise_error
    end
  end
end