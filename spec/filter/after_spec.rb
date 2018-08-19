require_relative "../../shift"

mock_folder_name = "./spec/filter/mock/after"

describe Shift::ShiftCore, "a user want to execute rules using after filter" do
  context "after filter failed" do
    it "should not excute rule" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "after_outdated")

      expect { core.execute_lane(:beta, folder) }.not_to raise_error
    end
  end
  context "after filter succeed" do
    it "should raise an error that describes a rule failure" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "error_failed")

      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::RuleError
    end
  end
end