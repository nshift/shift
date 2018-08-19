require_relative "../../shift"

mock_folder_name = "./spec/lane/mock"

describe Shift::ShiftCore, "a user want to execute a lane called :beta" do
  context ":beta lane does not exit in Shift file" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "no_beta_lane")

      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::LaneNotFound
    end
  end
  context "Shift file does not exist" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "non_existing_shift_file")

      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::ShiftFileNotFound
    end
  end
  context ":beta lane contains not found command" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "beta_command_not_found")

      expect { core.execute_lane(:beta, folder) }.to raise_error NameError
    end
  end
  context "Shift file has syntax error" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "beta_syntax_error")

      expect { core.execute_lane(:beta, folder) }.to raise_error SyntaxError
    end
  end
  context ":beta lane exist" do
    it "should execute the :beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "beta_lane")

      expect { core.execute_lane(:beta, folder) }.not_to raise_error
    end
  end
end