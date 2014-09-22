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
          c.option 'jekyll', '--jekyll', "Launch local server with docs for Jekyll v#{Jekyll::VERSION}"

          c.action do |args, options|
            serve_docs(options)
          end
        end
      end

      def self.serve_docs(options)
        if options['jekyll']
          options = init_jekyll_docs(options)
        else
          options = init_octopress_docs(options)
        end
        options["serving"] = true
        options = Jekyll.configuration Jekyll::Utils.symbolize_hash_keys(options)
        Jekyll::Commands::Build.process(options)
        Jekyll::Commands::Serve.process(options)
      end

      def self.init_octopress_docs(options)
        Octopress.config({
          'config-file' => File.join(site_dir, '_octopress.yml'),
          'override' => { 'docs_mode' => true }
        })
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
        config = Octopress.site.config

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
        if (Octopress.site.config['plugins'] == Jekyll::Configuration::DEFAULTS['plugins'])
          [Jekyll.sanitized_path(Octopress.site.source, Octopress.site.config['plugins'])]
        else
          Array(Octopress.site.config['plugins']).map { |d| File.expand_path(d) }
        end
      end
      
    end
  end
end
