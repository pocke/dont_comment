module DontComment
  module Formatter
    class JSON < Base
      def format(io)
        array = @offenses.map do |offense|
          loc = offense.loc
          {
            path: offense.relative_path,
            location: {
              start_line: loc.line,
              start_column: loc.column,
              end_line: loc.last_line,
              end_column: loc.last_column,
            }
          }
        end

        json = ::JSON.generate(array)
        io.print(json)
      end
    end
  end
end
