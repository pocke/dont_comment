require "dont_comment/version"
require 'parser/current'

module DontComment
  def self.execute(argv)
    files = argv
    files.each do |fname|
      parser = Parser::CurrentRuby.new
      buffer = buffer(fname)
      locs = comment_locations(parser, buffer)
      locs.each do |loc|
        puts to_text(loc)
        p '----------------------------'
      end
    end
  end

  def self.buffer(fname)
    Parser::Source::Buffer.new(fname, 1).tap do |buffer|
      buffer.source = File.read(fname)
    end
  end

  # @example
  # One comment
  #   # foo
  #   # bar
  #   def foo; end
  #
  # One comment
  #   # foo
  #   def foo; end
  #
  # Two comments
  #   # foo
  #   def foo; end
  #   # bar
  def self.comment_locations(parser, buffer)
    _ast, comments, _tokens = parser.tokenize(buffer)

    comments.each_with_object([]) do |comment, locs|
      prev = locs.last
      cur = comment.loc.expression

      if prev && continuous_comment?(prev, cur)
        locs[locs.size-1] = prev.join(cur)
      else
        locs.push(cur)
      end
    end.freeze
  end

  # @param prev [Parser::Source::Range]
  # @param cur [Parser::Source::Range]
  def self.continuous_comment?(prev, cur)
    range_between(prev, cur).source.match?(/\A\s*\z/)
  end

  # @param prev [Parser::Source::Range]
  # @param cur [Parser::Source::Range]
  def self.range_between(prev, cur)
    Parser::Source::Range.new(prev.source_buffer, prev.end_pos, cur.begin_pos)
  end

  # @param loc [Parser::Source::Range]
  # @return [String]
  def self.to_text(loc)
    source = loc.source
    source.each_line.map do |line|
      line[/^\s*\#(.+)$/, 1]
    end.join("\n")
  end
end
