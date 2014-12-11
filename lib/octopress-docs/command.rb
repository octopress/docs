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
        # Activate dependencies for serving docs.
        require "octopress-escape-code"
        require "octopress-hooks"
        require "octopress-docs/page"
        require "octopress-docs/doc"
        require "octopress-docs/hooks"
        require "octopress-docs/liquid_filters"

        ENV['OCTOPRESS_DOCS'] = true
        options = init_octopress_docs(options)
        options["port"] ||= '4444'
        options["serving"] = true
        options = Jekyll.configuration Jekyll::Utils.symbolize_hash_keys(options)
        Jekyll::Commands::Build.process(options)
        Jekyll::Commands::Serve.process(options)
      end

      def self.init_octopress_docs(options)
        require_plugins
        options['source'] = site_dir
        options['destination'] = File.join(site_dir, '_site')
        options
      end

      def self.init_jekyll_docs(options)
        options.delete('jekyll')

        # Find local Jekyll gem path
        #
        spec = Gem::Specification.find_by_name("jekyll")
        gem_path = spec.gem_dir

        options['source'] = "#{gem_path}/site",
        options['destination'] = "#{gem_path}/site/_site"
        options
      end

      def self.site_dir
        Docs.gem_dir('docs')
      end

      def self.require_plugins
        config = Octopress::Configuration.jekyll_config

        if config['gems'].is_a?(Array)
          config['gems'].each {|g| require g }
        end

        unless config['safe']
          plugins_path.each do |plugins|
            Dir[File.join(plugins, "**", "*.rb")].sort.each do |f|
              require f
            end
          end
        end
        
      end

      # Returns an Array of plugin search paths
      def self.plugins_path
        config = Octopress::Configuration.jekyll_config
        plugins = config['plugins']
        if (plugins == Jekyll::Configuration::DEFAULTS['plugins'])
          [Jekyll.sanitized_path(config['source'], plugins)]
        else
          Array(plugins).map { |d| File.expand_path(d) }
        end
      end
      
    end
  end
end
