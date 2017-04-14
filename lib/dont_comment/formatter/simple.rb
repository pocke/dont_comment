module DontComment
  module Formatter
    class Simple < Base
      def initialize(offenses)
        @offenses = offenses
      end

      def format(io)
        @offenses.each do |offense|
          io.puts "#{offense.relative_path}:#{offense.loc.line}: Do not comment out Ruby code"
        end
      end
    end
  end
end
