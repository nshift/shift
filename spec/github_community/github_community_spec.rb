require_relative "../../shift"

mock_folder_name = "./spec/github_community/mock"

describe Shift::ShiftCore, "a user want to validate the implementation of Github community standard" do
  context "with issue template files missing" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      Dir.chdir(mock_folder_name + '/missing_issue_template') do
        folder = Shift::ShiftFolder.new('missing_issue_template')
        expect { core.execute_lane(:beta, folder) }.to raise_error Shift::BuiltIn::GithubCommunity::ValidationError
      end
    end
  end
  context "with pull request template files missing" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      Dir.chdir(mock_folder_name + '/missing_pr_template') do
        folder = Shift::ShiftFolder.new('missing_pr_template')
        expect { core.execute_lane(:beta, folder) }.to raise_error Shift::BuiltIn::GithubCommunity::ValidationError
      end
    end
  end
  context "with readme file missing" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      Dir.chdir(mock_folder_name + '/missing_readme') do
        folder = Shift::ShiftFolder.new('missing_readme')
        expect { core.execute_lane(:beta, folder) }.to raise_error Shift::BuiltIn::GithubCommunity::ValidationError
      end
    end
  end
  context "with contibuting file missing" do
    it "should not execute the :beta lane" do
      core = Shift::ShiftCore.new
      Dir.chdir(mock_folder_name + '/missing_contributing') do
        folder = Shift::ShiftFolder.new('missing_contributing')
        expect { core.execute_lane(:beta, folder) }.to raise_error Shift::BuiltIn::GithubCommunity::ValidationError
      end
    end
  end
  context "with all existing Github community files" do
    it "should execute the :beta lane" do
      core = Shift::ShiftCore.new
      Dir.chdir(mock_folder_name + '/existing_github_community_files') do
        folder = Shift::ShiftFolder.new('existing_github_community_files')
        expect { core.execute_lane(:beta, folder) }.not_to raise_error
      end
    end
  end
end