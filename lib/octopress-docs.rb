require "octopress"
require "jekyll"
require "octopress-escape-code"
require "octopress-hooks"
require "find"

require "octopress-docs/version"
require "octopress-docs/command"
require "octopress-docs/page"
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
      docs = @docs.clone
      docs.each { |slug, pages|
        docs[slug] = {
          "name" => pages.first.plugin_name,
          "docs" => plugin_docs(pages)
        }
      }

      { 'plugin_docs' => docs }
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

    def self.add_plugin_docs(plugin)
      plugin_doc_pages = []
      options = plugin_options(plugin)
      find_doc_pages(options).each do |doc|
        unless doc =~ /^_/
          opts = options.merge({file: doc, dir: options[:docs_path]})   
          plugin_doc_pages << add_doc_page(opts)
        end
      end

      # If there is no docs index page, set the reame as the index page
      has_index = !plugin_doc_pages.select {|d| d.file =~ /^index/ }.empty?
      plugin_doc_pages << add_root_plugin_doc(plugin, 'readme', index: !has_index)

      plugin_doc_pages << add_root_plugin_doc(plugin, 'changelog')

      plugin_doc_pages
    end

    def self.plugin_options(plugin)
      {
        name: plugin.name,
        slug: plugin.slug,
        type: plugin.type,
        base_url: plugin.docs_url,
        dir: plugin.path,
        docs_path: File.join(plugin.assets_path, 'docs'),
        docs: %w{readme changelog}
      }
    end

    def self.default_options(options)
      options[:type] ||= 'plugin'
      options[:slug] = slug(options)
      options[:base_url] = base_url(options)
      options[:dir] ||= '.'
    end

    def self.slug(options)
      slug = options[:slug] || options[:name]
      options[:type] == 'theme' ? 'theme' : Jekyll::Utils.slugify(slug)
    end
    
    def self.base_url(options)
      options[:base_url] || if options[:type] == 'theme'
        File.join('docs', 'theme')
      else
        File.join('docs', 'plugins', options[:slug])
      end
    end

    def self.add(options)
      options[:docs] ||= %w{readme changelog}
      options[:docs_path] ||= File.join(options[:dir], 'assets', 'docs')
      docs = []
      docs.concat add_root_docs(options)
      docs.compact! 
    end

    def self.add_root_docs(options)
      root_docs = []
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

    private

    def self.find_doc_pages(options)
      full_dir = options[:docs_path]
      glob_assets(full_dir).map do |file|
        file.sub(full_dir+'/', '')
      end
    end

    def self.glob_assets(dir)
      return [] unless Dir.exist? dir
      Find.find(dir).to_a.reject {|f| File.directory? f }
    end

    def self.select_first(dir, match)
      Dir.new(dir).select { |f| f =~/#{match}/i}.first
    end

  end
end
