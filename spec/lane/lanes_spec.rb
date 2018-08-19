require_relative "../../shift"
require_relative '../built_in_service_mock'

mock_folder_name = "./spec/lane/mock"

describe Shift::ShiftCore, "a user want to execute lanes using conditions" do
	it "should execute lanes and conditions in the right order" do
    mock = BuiltInServiceMock.new
		core = Shift::ShiftCore.new(mock)
    folder = Shift::ShiftFolder.new(mock_folder_name, "beta_lane_conditions")
		
    core.execute_lanes(folder)

    expect(mock.history[0]).to eq("__test before_all")
    expect(mock.history[1]).to eq("__test :beta before_each")
    expect(mock.history[2]).to eq("__test :beta lane")
    expect(mock.history[3]).to eq("__test :beta after_each")
    expect(mock.history[4]).to eq("__test :staging before_each")
    expect(mock.history[5]).to eq("__test :staging lane")
    expect(mock.history[6]).to eq("__test :staging after_each")
    expect(mock.history[7]).to eq("__test after_all")
	end
end