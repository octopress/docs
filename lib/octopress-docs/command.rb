module Octopress
  module Docs
    class Commands < Octopress::Command
      def self.init_with_program(p)
        p.command(:docs) do |c|
          c.syntax 'octopress docs'
          c.description "Launch local server with docs for Octopress v#{Octopress::VERSION} and Octopress plugins."

          c.option 'port', '-P', '--port [PORT]', 'Port to listen on'
          c.option 'host', '-H', '--host [HOST]', 'Host to bind to'
          if ENV['OCTODEV']
            c.option 'watch', '--watch', 'Watch docs site for changes and rebuild. (For docs development)'
          end

          c.action do |args, options|
            serve_docs(options)
          end
        end
      end

      def self.serve_docs(options)
        # Tell the world, we're serving the docs site
        #
        ENV['OCTOPRESS_DOCS'] = 'true'

        # Activate dependencies for serving docs.
        #
        require "octopress-hooks"
        require "octopress-escape-code"
        require "octopress-docs/jekyll/convertible"
        require "octopress-docs/jekyll/page"
        require "octopress-docs/doc"
        require "octopress-docs/hooks"
        require "octopress-docs/liquid_filters"

        # Look at the local site and require all of its plugins
        # Ensuring their documentation is loaded into the docs site
        #
        Octopress.site({'config'=>options['config']}).plugin_manager.conscientious_require

        options = init_octopress_docs(options)
        
        Dir.chdir(options['source']) do
          Jekyll::Commands::Build.process(options)
          Jekyll::Commands::Serve.process(options)
        end
      end

      # Prepare Jekyll to serve up the site from this gem
      #
      def self.init_octopress_docs(options)
        options['source']      = Docs.gem_dir('site')
        options['destination'] = File.join(options['source'], '_site')
        options['port']        = '4444'
        options['serving']     = true

        # Merge with Jekyll defaults and load in site's _config.yml
        #
        Jekyll.configuration(options)
      end
    end
  end
end
