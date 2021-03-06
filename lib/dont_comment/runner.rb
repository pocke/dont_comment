module DontComment
  class Runner
    def initialize(files)
      @files = files
    end

    def run
      # TODO: configuralbe ruby version
      parser_class = Parser::CurrentRuby
      @files.map do |fname|
        parser = parser_class.new
        buffer = buffer(fname)
        locs = comment_locations(parser, buffer)

        ruby_code_locs = locs.select do |loc|
          text = to_text(loc)
          parsable?(parser_class, text) &&
            like_ruby_code?(text)
        end

        ruby_code_locs.map{|loc| Offense.new(loc, fname)}
      end.flatten
    end

    private

    def buffer(fname)
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
    def comment_locations(parser, buffer)
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
    def continuous_comment?(prev, cur)
      range_between(prev, cur).source.match?(/\A\s*\z/)
    end

    # @param prev [Parser::Source::Range]
    # @param cur [Parser::Source::Range]
    def range_between(prev, cur)
      Parser::Source::Range.new(prev.source_buffer, prev.end_pos, cur.begin_pos)
    end

    # @param loc [Parser::Source::Range]
    # @return [String]
    def to_text(loc)
      source = loc.source
      source.each_line.map do |line|
        line[/^\s*\#(.+)$/, 1]
      end.join("\n")
    end

    # @param parser_class [Class]
    # @param source [String]
    # @return [true|false]
    def parsable?(parser_class, source)
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
    def like_ruby_code?(source)
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
end
