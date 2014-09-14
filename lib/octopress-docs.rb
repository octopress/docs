require "octopress"
require "jekyll"
require "octopress-escape-code"

require "octopress-docs/version"
require "octopress-docs/command"
require "octopress-docs/doc"
require "octopress-docs/tag"

module Octopress
  module Docs
    attr_reader :pages
    @pages = []

    autoload :Doc, 'octopress-docs/doc'

    def self.gem_dir(dir='')
      File.expand_path(File.join(File.dirname(__FILE__), '../', dir))
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
        plugin_name: plugin.name,
        plugin_slug: plugin.slug,
        plugin_type: plugin.type,
        base_url: plugin.docs_base_url,
        dir: plugin.path
      }
    end

    def self.add(options)
      root_docs = []
      options[:docs] ||= %w{readme changelog}
      options[:docs].each do |doc|
        root_docs << add_root_doc(doc, options)
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
      @pages << page
      page
    end

    def self.select_first(dir, match)
      Dir.new(dir).select { |f| f =~/#{match}/i}.first
    end
  end
end
