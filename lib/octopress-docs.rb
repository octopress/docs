require "octopress"
require "jekyll"
require "find"

require "octopress-docs/version"
require "octopress-docs/command"

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
          "docs" => plugin_docs(pages),
          "url"  => pages.first.base_url,
          "type"  => pages.first.plugin_type,
          "description"  => pages.first.description,
          "source_url"  => pages.first.source_url
        }
      }

      docs = docs.sort_by { |k,v| v['name'] }

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
      options = plugin_options(plugin)
      options[:docs] ||= %w{readme docs}

      plugin_doc_pages = add_asset_docs(options)
      plugin_doc_pages.concat add_root_docs(options, plugin_doc_pages)
      plugin_doc_pages
    end

    def self.plugin_options(plugin)
      {
        name: plugin.name,
        slug: plugin.slug,
        type: plugin.type,
        base_url: plugin.docs_url,
        path: plugin.path,
        source_url: plugin.source_url,
        website: plugin.website,
        docs_path: File.join(plugin.assets_path, 'docs'),
        docs: %w{readme changelog}
      }
    end

    def self.default_options(options)
      options[:type] ||= 'plugin'
      options[:slug] = slug(options)
      options[:base_url] = base_url(options)
      options[:path] ||= '.'
      options
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
      options = default_options(options)
      options[:docs_path] ||= File.join(options[:path], 'assets', 'docs')
      docs = []
      docs.concat add_asset_docs(options)
      docs.concat add_root_docs(options, docs)
      docs.compact! 
    end

    def self.add_root_docs(options, asset_docs=[])
      root_docs = []
      options[:docs].each do |doc|
        doc_data = {
          'title' => doc.capitalize
        }

        if doc =~ /readme/ && asset_docs.select {|d| d.file =~ /^index/ }.empty?
          doc_data['permalink'] = '/'
        end

        root_docs << add_root_doc(doc, options.merge(data: doc_data))
      end
      root_docs
    end

    # Add a single root doc
    def self.add_root_doc(filename, options)
      if file = select_first(options[:path], filename)
        add_doc_page(options.merge({file: file}))
      end
    end

    def self.add_doc_page(options)
      page = Docs::Doc.new(options)
      @docs[options[:slug]] ||= []
      @docs[options[:slug]] << page
      page
    end

    private

    def self.add_asset_docs(options)
      docs = []
      find_doc_pages(options).each do |doc|
        unless doc =~ /^_/
          opts = options.merge({file: doc, path: options[:docs_path]})   
          docs << add_doc_page(opts)
        end
      end
      docs
    end

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

# Add documentation for this plugin

Octopress::Docs.add({
  name:        "Octopress Docs",
  description: "The fancy local documentation viewer.",
  source_url:  "https://github.com/octopress/docs",
  path:         File.expand_path(File.join(File.dirname(__FILE__), "../"))
})
