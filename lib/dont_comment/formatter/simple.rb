module DontComment
  module Formatter
    class Simple < Base
      def format(io)
        @offenses.each do |offense|
          io.puts "#{offense.relative_path}:#{offense.loc.line}: Do not comment out unused code, use version control system instead and remove it!"
        end
      end
    end
  end
end
