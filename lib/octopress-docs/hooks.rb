module Octopress
  module Docs
    class DocsSiteHook < Octopress::Hooks::Site
      def post_read(site)
        if Octopress.config['docs_mode']
          site.pages.concat Octopress::Docs.pages
        end
      end

      def merge_payload(payload, site)
        if Octopress.config['docs_mode']
          Octopress::Docs.pages_info
        end
      end
    end
  end
end
