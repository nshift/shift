require 'date'

module Shift
  module Filter
    class Before
      def initialize(arguments)
        @arguments = arguments
      end

      def name
        return File.basename(__FILE__, File.extname(__FILE__))
      end

      def validate?
        return Date.today < Date.parse(@arguments.first)
      end
    end
  end
end