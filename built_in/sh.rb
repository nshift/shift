require 'open3'

module Shift
  module BuiltIn
    class Sh

      def self.name
        return File.basename(__FILE__, File.extname(__FILE__))
      end

      def self.execute(arguments)
        result = ''
        exit_status = nil
        Open3.popen2e(arguments.first.to_s) do |stdin, io, thread|
          io.sync = true
          io.each do |line|
            puts line.strip
            result << line
          end
          exit_status = thread.value.exitstatus
        end
        raise BuiltInFailed.new(result) if exit_status != 0
        return result
      end
    end
  end
end