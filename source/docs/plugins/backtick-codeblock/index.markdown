---
layout: page
title: "Backtick Code Blocks"
date: 2011-07-26 23:42
sidebar: false
footer: false
---

With the `backtick_codeblock` filter you can use Github's lovely back tick syntax highlighting blocks.
Simply start a line with three back ticks followed by a space and the language you're using.

## Syntax

    ``` [language] [title] [url] [link text]
    code snippet
    ```
### Basic options

- `[language]` - Used by the syntax highlighter. Passing 'plain' disables highlighting. ([Supported languages](http://pygments.org/docs/lexers/).)
- `[title]` - Add a figcaption to your code block.
- `[url]` - Download or reference link for your code.
- `[Link text]` - Text for the link, defaults to 'link'.

{% render_partial docs/plugins/_partials/options.markdown %}

## Examples

**1.** Here's an example without setting the language.

```
$ git clone git@github.com:imathis/octopress.git # fork octopress
```

*The source:*

    ```
    $ git clone git@github.com:imathis/octopress.git # fork octopress
    ```

**2.** This example uses syntax highlighting and a code link.

``` ruby Discover if a number is prime http://www.noulakaz.net/weblog/2007/03/18/a-regular-expression-to-check-for-prime-numbers/ Source Article
class Fixnum
  def prime?
    ('1' * self) !~ /^1?$|^(11+?)\1+$/
  end
end
```

*The source:*

    ``` ruby Discover if a number is prime http://www.noulakaz.net/weblog/2007/03/18/a-regular-expression-to-check-for-prime-numbers/ Source Article
    class Fixnum
      def prime?
        ('1' * self) !~ /^1?$|^(11+?)\1+$/
      end
    end
    ```

### Other ways to embed code snippets

You might also like to [embed code from a file](/docs/plugins/include-code) or [embed GitHub gists](/docs/plugins/gist-tag).
