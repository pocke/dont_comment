require 'test_helper'

class TestCLI < Minitest::Test
  def test_validate_format_option
    devnull = StringIO.new
    cli = DontComment::CLI.new(%w[--format json ], devnull)
    cli.run # Do not raise error

    cli = DontComment::CLI.new(%w[--format foobar], devnull)
    assert_raises(DontComment::CLI::ValidateError) { cli.run }
  end
end
