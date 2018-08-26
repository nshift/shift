require_relative "../../shift"

mock_folder_name = "./spec/git_flow/mock"

describe Shift::ShiftCore, "a user want to validate the presence of Git flow" do
  context "with master branch missing" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, 'missing_master')
      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::BuiltIn::GitFlow::ValidationError
    end
  end
  context "with develop branch missing" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, 'missing_develop')
      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::BuiltIn::GitFlow::ValidationError
    end
  end
  context "with branch does not follow the Git flow standard" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, 'not_follow_git_flow_standard')
      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::BuiltIn::GitFlow::ValidationError
    end
  end
  context "with all the branches follow the Git flow standard" do
    it "should execute the :beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, 'follow_git_flow_standard')
      expect { core.execute_lane(:beta, folder) }.not_to raise_error
    end
  end
end