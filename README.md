# DontComment

[![Gem Version](https://badge.fury.io/rb/dont_comment.svg)](https://badge.fury.io/rb/dont_comment)
[![Build Status](https://travis-ci.org/pocke/dont_comment.svg?branch=master)](https://travis-ci.org/pocke/dont_comment)

Do not comment out unused code, use version control system instead and remove it!


## What's this?

If you use version control system, you must not comment out unused code.

For example, you can remove the old implementation in the following code.

```ruby
# def some_method
#   puts 'an old implementation'
# end

def some_method
  puts 'a new implementation'
end
```

This tool detects this problem.


### Detect comment outs for debug

```ruby
class ExampleController < ApplicationController
  # before_action :validate_foobar
end
```

Sometime we comment out validation or something for debug.
If we forget to restore the comment before we commit the change, it will be a serious bug.

We can avoid the bug by this tool.

### False positives

Maybe, This tools will make many false positives.
I design this tools to use with a pull-request.
Do not use use this tool for all ruby files in your repository. It probably will not be useful.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dont_comment'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dont_comment

### Requirements

- Ruby 2.4 or higher

## Usage

```bash
$ dont_comment some/ruby/file/path.rb
some/ruby/file/path.rb:3: Do not comment out unused code, use version control system instead and remove it!
some/ruby/file/path.rb:7: Do not comment out unused code, use version control system instead and remove it!
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/dont_comment.

