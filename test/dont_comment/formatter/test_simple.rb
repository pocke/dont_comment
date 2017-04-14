require 'test_helper'

class TestFormatterSimple < Minitest::Test
  def test_format
    offenses = [
      DontComment::Offense.new(loc_stub(1), "hoge.rb"),
      DontComment::Offense.new(loc_stub(42), "fuga.rb"),
    ]

    f = DontComment::Formatter::Simple.new(offenses)
    io = StringIO.new
    f.format(io)
    expected = <<~END
      hoge.rb:1: Do not comment out Ruby code
      fuga.rb:42: Do not comment out Ruby code
    END
    assert { io.string == expected}
  end

  def loc_stub(line)
    Struct.new(:line).new(line)
  end
end
