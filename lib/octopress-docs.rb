require "octopress"
require "jekyll"
require "octopress-escape-code"
require "octopress-hooks"

require "octopress-docs/version"
require "octopress-docs/command"
require "octopress-docs/doc"
require "octopress-docs/tag"
require "octopress-docs/hooks"

module Octopress
  module Docs
    attr_reader :docs
    @docs = {}

    autoload :Doc, 'octopress-docs/doc'

    def self.gem_dir(dir='')
      File.expand_path(File.join(File.dirname(__FILE__), '../', dir))
    end

    # Get all doc pages
    #
    def self.pages
      @docs.values.flatten.map {|d| d.page }
    end

    def self.pages_info
      plugin_docs = []
      @docs.keys.each { |slug|
        plugin_docs << {
          "name" => @docs[slug].first.plugin_name,
          "docs" => plugin_docs(@docs[slug])
        }
      }
      { 'plugin_docs' => plugin_docs }
    end

    def self.plugin_docs(pages)
      pages.clone.map { |d|
        page = d.page
        title   = page.data['link_title'] || page.data['title'] || page.basename
        url = File.join('/', d.base_url, page.url.sub('index.html', ''))

        {
          'title' => title,
          'url' => url
        }
      }.sort_by { |i| 
        # Sort by depth of url
        i['url'].split('/').size
      }
    end

    def self.add_plugin_docs(plugin, dir, files)
      pages = []
      options = plugin_options(plugin).merge({
        dir: File.join(plugin.assets_path, dir),
      })

      files.each do |doc|
        unless doc =~ /^_/
          opts = options.merge({file: doc})   
          pages << add_doc_page(opts)
        end
      end

      pages
    end

    def self.plugin_options(plugin)
      {
        name: plugin.name,
        slug: plugin.slug,
        type: plugin.type,
        base_url: plugin.docs_base_url,
        dir: plugin.path
      }
    end

    def self.add(options)

      root_docs = []
      options[:docs] ||= %w{readme changelog}
      options[:docs].each do |doc|
        if doc =~ /readme/
          root_docs << add_root_doc(doc, options.merge({index: true}))
        else
          root_docs << add_root_doc(doc, options)
        end
      end
      root_docs
    end

    # Add a single root doc
    def self.add_root_doc(filename, options)
      if file = select_first(options[:dir], filename)
        add_doc_page(options.merge({file: file}))
      end
    end

    def self.add_root_plugin_doc(plugin, filename, options={})
      options = plugin_options(plugin).merge(options)
      add_root_doc(filename, options)
    end

    def self.add_doc_page(options)
      page = Docs::Doc.new(options)
      @docs[options[:slug]] ||= []
      @docs[options[:slug]] << page
      page
    end

    def self.select_first(dir, match)
      Dir.new(dir).select { |f| f =~/#{match}/i}.first
    end
  end
end
