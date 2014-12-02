# Octopress Docs

If you have the Octopress gem installed, run `$ octopress docs` from the root of your Jekyll site, and a website will mount at `http://localhost:4444` with documentation for Octopress and any plugins which support this feature.

## Adding docs to your plugin

Use the code below to automatically add your plugin's Readme, Changelog and any pages in your gem path under `assets/docs`.
If your plugin is built on Octopress Ink, these documentation pages are added automatically.

```ruby
require 'octopress-docs'
Octopress::Docs.add({
  name:        "Your Plugin",
  description: "This plugin causes awesomeness",
  dir:         File.expand_path(File.join(File.dirname(__FILE__), "../../")),
  slug:        "your-plugin",                      # optional
  source_url:  "https://github.com/some/project",  # optional
  website:     "http://example.com",               # optional
})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
