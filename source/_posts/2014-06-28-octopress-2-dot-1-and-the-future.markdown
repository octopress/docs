---
layout: post
title: "Octopress 2.1 and the Future"
date: 2014-06-28 15:51:05 -0500
comments: true
categories: 
---

There's a lot to talk about, but first we'll look at what's new in 2.1 and how to get up to date.

### Jekyll 2.0

The Jekyll team has been rocking and rolling lately, and Octopress will now let you use the latest and greatest from Jekyll. I'm really
excited about how Jekyll has grown lately. Check out their [2.0 blog post](http://jekyllrb.com/news/2014/05/06/jekyll-turns-2-0-0/) if you
you want to see what's new.

### New syntax highlighting plugins

Now all of the code plugins for Octopress are shipped as separate ruby gems.

- [octopress-gist](https://github.com/octopress/gist) - Downloads and highlights gists using GitHub's API.
- [octopress-codefence](https://github.com/octopress/codefence) - The backtick code block.
- [octopress-codeblock](https://github.com/octopress/codefence) - The Liquid block highlighter.
- [octopress-render-code](https://github.com/octopress/render-code) - Render code from your file system (the old include_code plugin).

Use these code plugins with Octopress or with any standard Jekyll site. They are built on
[octopress-code-highlighter](https://github.com/octopress/code-highlighter) which generates the HTML. You can use use the default
[Pygments.rb](https://github.com/tmm1/pygments.rb) highlighter or switch to [Rouge](https://github.com/jneen/rouge) a new pure-ruby to highlight your code snippets.


### New code styles

As I worked on the new syntax highlighting plugins I also improved the HTML they generate. Due to these changes the old stylesheets, and many third party themes, are
out of date and won't properly style the new code snippets. I've rewritten the stylesheets to and launched them as a separate gem,
[octopress-solarized](https://github.com/octopress/solarized).  If you're using the classic theme, you can update your stylesheets with `rake update_style` and you'll get
the new styles.


```elixir Some random Elixir example mark:2 url:http://devintorr.es/blog/2013/01/22/the-excitement-of-elixir/ link_text:source class:light
defrecord Foo, bar: "baz", quux: nil
x = Foo.new
x.bar #=> "baz"
x = x.quux "corge" #=> Foo[bar: "baz", quux: "corge"]
x.to_keywords[:bar] #=> "baz"
```

```elixir Some random Elixir example mark:2 url:http://devintorr.es/blog/2013/01/22/the-excitement-of-elixir/ link_text:source
defrecord Foo, bar: "baz", quux: nil
x = Foo.new
x.bar #=> "baz"
x = x.quux "corge" #=> Foo[bar: "baz", quux: "corge"]
x.to_keywords[:bar] #=> "baz"
```
