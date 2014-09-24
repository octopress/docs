# Octopress Docs

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'octopress-docs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install octopress-docs

## Usage

Automatically add your Readme and Changelog files along with any pages in your gem path under `/assets/docs`.

```ruby
begin
  require 'octopress-docs'
  Octopress::Docs.add({
    name:        "Your Plugin",
    slug:        "your-plugin",
    dir:         File.expand_path(File.join(File.dirname(__FILE__), "../../"))
  })
rescue LoadError
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
