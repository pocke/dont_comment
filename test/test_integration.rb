require 'test_helper'
require 'open3'

class TestIntegration < Minitest::Test
  def test_specified_one_file
    exe = Pathname(__dir__).join('../exe/dont_comment').to_s
    rb = Pathname(__dir__).join('data/sample.rb').to_s
    stdout, _stderr, status = Open3.capture3('ruby', exe, rb)
    assert { status.success? }

    lines = stdout.each_line.to_a
    assert { lines.size == 2 }

    assert { lines[0].chomp == '/home/pocke/ghq/github.com/pocke/dont_comment/test/data/sample.rb:3: Do not comment out Ruby code'}
    assert { lines[1].chomp == '/home/pocke/ghq/github.com/pocke/dont_comment/test/data/sample.rb:7: Do not comment out Ruby code'}
  end
end
