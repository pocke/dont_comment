module DontComment
  module Formatter
    class Base
      def initialize(offenses)
        @offenses = offenses
      end

      def format(_io)
        raise "Implement this method!"
      end
    end
  end
end
