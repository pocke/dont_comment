require 'test_helper'

class TestCLI < Minitest::Test
  def test_validate_format_option
    cli = DontComment::CLI.new(%w[--format json ])
    cli.run # Do not raise error

    cli = DontComment::CLI.new(%w[--format foobar])
    assert_raises(DontComment::CLI::ValidateError) { cli.run }
  end
end
