require "dont_comment/version"
require 'parser/current'

module DontComment
  def self.execute(argv)
    files = argv
    files.each do |file|
      parser = Parser::CurrentRuby.new
      _ast, comment, _tokens = parser.tokenize(buffer(file))
    end
  end

  def self.buffer(fname)
    Parser::Source::Buffer.new(fname, 1).tap do |buffer|
      buffer.source = File.read(fname)
    end
  end
end
