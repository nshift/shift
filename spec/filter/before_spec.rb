require_relative "../../shift"

mock_folder_name = "./spec/filter/mock/before"

describe Shift::ShiftCore, "a user want to execute rules using before filter" do
  context "before filter failed" do
    it "should not excute rule" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "before_outdated")

      expect { core.execute_lane(:beta, folder) }.not_to raise_error
    end
  end
  context "before filter succeed" do
    it "should raise an error that describes a rule failure" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "error_failed")

      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::RuleError
    end
  end
end