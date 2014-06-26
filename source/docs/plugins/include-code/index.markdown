---
layout: page
title: "Include Code"
date: 2011-07-22 09:13
updated: 201-08-21 16:18
sidebar: false
footer: false
---

Import files on your filesystem into any blog post as embedded code snippets with syntax highlighting and a download link.
In the `_config.yml` you can set your `code_dir` but the default is `source/downloads/code`. Simply put a file anywhere under that directory and
use the following tag to embed it in a post.

## Syntax

```
{% render_code path/to/file [title] [lang:language] [start:#] [end:#] [range:#-#] [mark:#,#-#] [linenos:false] %}
```

### Basic options

- `[title]` - Add a custom figcaption to your code block (defaults to filename).
- `lang:language` - Force the syntax highlighter to use this language. By default the file extension is used for highlighing, but not all extensions are known by Pygments.

{% assign show-range = true %}
{% render_partial docs/plugins/_partials/options.markdown %}

## Examples

**1.** This code snipped was included from `source/downloads/code/test.js`.

{% render_code test.js %}

*The source:*

```
{% render_code test.js %}
```

**2.** Setting a custom caption.

{% render_code ruby/test.rb Add to_fraction for floats %}

*The source:*

```
{% render_code ruby/test.rb  Add to_fraction for floats %}
```

This includes a file from `source/downloads/code/ruby/test.rb`.


### Including part of a file

**3.** Embed a file starting from a specific line.

{% render_code test.js start:10 %}

*The source:* 

```
{% render_code test.js start:10 %}
```

**4.** Embed a file ending at a specific line.

{% render_code test.js end:10 %}

*The source:*

```
{% render_code test.js end:10 %}
```

**5.** Display only the lines in a specific range.

{% render_code test.js range:5-16 %}

*The source:*

```
{% render_code test.js range:5-16 %}
```

### Other ways to embed code snippets

You might also like to [use back tick code blocks](/docs/plugins/backtick-codeblock) or [embed GitHub gists](/docs/plugins/gist-tag).
