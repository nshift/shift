# require 'forwardable'

module Shift
  class LaneNotFound < CommandFailed
  end

  class LaneService
    def execute_lane(lane_name, shift_file)
      unless shift_file && block = shift_file[:lanes].fetch(lane_name, nil)
        raise LaneNotFound.new("#{lane_name} does not exist")
      end
      shift_file[:before_all_block].call if shift_file[:before_all_block]
      shift_file[:before_each_block].call(lane_name) if shift_file[:before_each_block]
      block.call
      shift_file[:after_each_block].call(lane_name) if shift_file[:after_each_block]
      shift_file[:after_all_block].call if shift_file[:after_all_block]
    end

    def execute_lanes(shift_file)
      shift_file[:before_all_block].call if shift_file[:before_all_block]
      shift_file[:lanes].each do |lane_name, block|
        shift_file[:before_each_block].call(lane_name) if shift_file[:before_each_block]
        block.call if block
        shift_file[:after_each_block].call(lane_name) if shift_file[:after_each_block]
      end
      shift_file[:after_all_block].call if shift_file[:after_all_block]
    end
  end
end