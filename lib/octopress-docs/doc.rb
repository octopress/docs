module Octopress
  module Docs
    class Doc
      attr_reader :filename, :plugin_name, :plugin_slug, :base_url, :plugin_type, :description, :source_url

      def initialize(options={})
        @file            = options[:file]
        @path            = options[:path] ||= '.'
        @file_dir        = File.dirname(@file)
        @plugin_name     = options[:name]
        @plugin_slug     = options[:slug]
        @plugin_type     = options[:type]
        @base_url        = options[:base_url]
        @source_url      = options[:source_url]
        @description     = options[:description]
        @data            = options[:data] || {}
      end

      # Add doc page to Jekyll pages
      #
      def add
        Octopress.site.pages << page
      end

      def disabled?
        false
      end

      def file
        File.basename(@file)
      end

      def info
        "  - #{permalink.ljust(35)}"
      end

      def page
        return @page if @page
        @page = Octopress::Docs::Page.new(Octopress.site, @path, page_dir, file, {'path'=>@base_url})
        @page.data['layout'] = 'docs'
        @page.data['plugin'] = { 
          'name'        => @plugin_name, 
          'slug'        => @plugin_slug,
          'type'        => @plugin_type,
          'source_url'  => @source_url,
          'description' => @description,
          'url'         => @base_url
        }

        @page.data['dir'] = doc_dir
        @page.data = @data.merge(@page.data)
        @page.data.merge!(comment_yaml(@page.content))
        @page
      end

      private

      def permalink
        File.basename(file, ".*")
      end

      def read
        File.open(File.join(@path, @file)).read
      end

      def plugin_slug
        Jekyll::Utils.slugify(@plugin_type == 'theme' ? 'theme' : @plugin_slug)
      end

      def page_dir
        @file_dir == '.' ? '' : @file_dir
      end

      def doc_dir
        File.join(@path, page_dir, File.dirname(@file))
      end

      def comment_yaml(content)
        if content =~ /<!-{3}\s+(.+)?-{3}>/m
          SafeYAML.load($1)
        else
          {}
        end
      end
    end
  end
end
