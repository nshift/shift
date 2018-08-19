require_relative "../../shift"

mock_folder_name = "./spec/file/mock"

describe Shift::ShiftCore, "a user want to check if REAMDE file exist" do
  context "README file does not exist" do
    it "should not execute beta lane" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "file_does_not_exist")

      expect { core.execute_lane(:beta, folder) }.to raise_error Shift::FileDoesNotExist
    end
  end
end