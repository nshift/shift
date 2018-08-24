require_relative "../../shift"

mock_folder_name = "./spec/guideline/mock"

describe Shift::ShiftCore, "a user want to validate the guideline implementation" do
  context ":beta lane does not exit in Shift file" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      Dir.chdir(mock_folder_name + '/missing_contributing') do
        folder = Shift::ShiftFolder.new('missing_contributing')
        expect { core.execute_lane(:beta, folder) }.to raise_error Shift::BuiltIn::Guideline::GithubCommunity::ValidationError
      end
    end
  end
  context "Shift file does not exist" do
    it "should execute the :beta lane" do
      core = Shift::ShiftCore.new
      Dir.chdir(mock_folder_name + '/valid') do
        folder = Shift::ShiftFolder.new('valid')
        expect { core.execute_lane(:beta, folder) }.not_to raise_error
      end
    end
  end
end