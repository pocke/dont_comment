module DontComment
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run
      files = @argv
      offenses = Runner.new(files).run
      Formatter::Simple.new(offenses).format($stdout)
    end
  end
end
