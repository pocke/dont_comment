module DontComment
  class CLI
    class ValidateError < StandardError; end

    FormatterMap = {
      simple: Formatter::Simple,
      json: Formatter::JSON,
    }

    def initialize(argv, out = $stdout)
      @argv = argv
      @config = default_config
      @out = out
    end

    def run
      parse_args
      validate_config

      files = @argv
      offenses = Runner.new(files).run
      formatter_class.new(offenses).format(@out)
    end

    private

    def parse_args
      o = OptionParser.new
      o.on('-f=FORMATTER', '--formatter=FORMATTER'){|v| @config[:formatter] = v.to_sym}

      o.parse!(@argv)
    end

    def validate_config
      raise ValidateError, "#{@config[:formatter]} is not a valid formatter name" unless formatter_class
    end

    def default_config
      {
        formatter: :simple,
      }
    end

    def formatter_class
      FormatterMap[@config[:formatter]]
    end
  end
end
