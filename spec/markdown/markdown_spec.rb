require_relative "../../shift"

mock_folder_name = "./spec/markdown/mock"

describe Shift::ShiftCore, "a user want to validate a markdown rule" do
  context "markdown file contains at least one bad link" do
    it "should fail to execute" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "bad_link")
      
      expect { core.execute_lanes(folder) }.to raise_error Shift::MarkdownContainsNotFoundLink
    end
  end
  context "command does not exist" do
    it "should fail to execute" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "bad_command")
      
      expect { core.execute_lanes(folder) }.to raise_error Shift::MarkdownUnknownCommand
    end
  end
  context "markdown file contains valid links only" do
    it "should succeed to execute" do
      core = Shift::ShiftCore.new
      folder = Shift::ShiftFolder.new(mock_folder_name, "valid_links")
      
      expect { core.execute_lanes(folder) }.not_to raise_error
    end
  end
end