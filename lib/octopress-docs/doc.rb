module Octopress
  module Docs
    class Doc
      attr_reader :filename, :plugin_name, :base_url

      def initialize(options={})
        @file            = options[:file]
        @dir             = options[:dir] ||= '.'
        @file_dir        = File.dirname(@file)
        @plugin_name     = options[:name]
        @plugin_slug     = options[:slug]
        @plugin_type     = options[:type]
        @base_url        = options[:base_url]
        @index           = options[:index]
      end

      # Add doc page to Jekyll pages
      #
      def add
        if Octopress.config['docs_mode']
          Octopress.site.pages << page
        end
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
        @page = Octopress::Docs::Page.new(Octopress.site, @dir, page_dir, file, {'path'=>@base_url})
        @page.data['layout'] = 'docs'
        @page.data['plugin'] = { 
          'name' => @plugin_name, 
          'slug' => plugin_slug,
          'docs_base_url' => @base_url
        }
        @page.data['dir'] = doc_dir
        @page.data['permalink'] = "/" if @index
        @page
      end

      private

      def permalink
        File.basename(file, ".*")
      end

      def read
        File.open(File.join(@dir, @file)).read
      end

      def plugin_slug
        Filters.sluggify @plugin_type == 'theme' ? 'theme' : @plugin_slug
      end

      def page_dir
        @file_dir == '.' ? '' : @file_dir
      end

      def doc_dir
        File.join(@dir, page_dir, File.dirname(@file))
      end

    end
  end
end
