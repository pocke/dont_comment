require "dont_comment/version"
require 'parser/current'
require 'stringio'

module DontComment
  def self.execute(argv)
    files = argv
    # TODO: configuralbe ruby version
    parser_class = Parser::CurrentRuby
    files.map do |fname|
      parser = parser_class.new
      buffer = buffer(fname)
      locs = comment_locations(parser, buffer)

      ruby_code_locs = locs.select do |loc|
        text = to_text(loc)
        parsable?(parser_class, text) &&
          like_ruby_code?(text)
      end

      ruby_code_locs.each do |loc|
        path = relative_path(fname)
        puts "#{path}:#{loc.line}: Do not comment out Ruby code"
      end
    end
  end

  def self.relative_path(path)
    pwd = Pathname.pwd
    absolute_path = pwd.join(path)
    absolute_path.relative_path_from(pwd)
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

  # @param parser_class [Class]
  # @param source [String]
  # @return [true|false]
  def self.parsable?(parser_class, source)
    stderr = $stderr
    $stderr = StringIO.new

    parser_class.parse(source)
    return true
  rescue Parser::SyntaxError
    return false
  ensure
    $stderr = stderr
  end

  # Check ascii
  # @param source [String]
  # @return [true|false]
  def self.like_ruby_code?(source)
    count_ascii = 0
    count_non_ascii = 0
    source.chars.each do |ch|
      if ch.match?(/[[:ascii:]]/)
        count_ascii += 1
      else
        count_non_ascii += 1
      end
    end

    count_ascii / (count_ascii + count_non_ascii).to_f > 0.7
  end
end
