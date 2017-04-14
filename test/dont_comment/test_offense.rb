require 'test_helper'

class TestOffense < Minitest::Test
  def test_relative_path
    offense = DontComment::Offense.new(nil, 'baz.rb')
    assert { offense.relative_path.to_s == 'baz.rb' }

    offense = DontComment::Offense.new(nil, 'foo/baz.rb')
    assert { offense.relative_path.to_s == 'foo/baz.rb' }
  end
end


