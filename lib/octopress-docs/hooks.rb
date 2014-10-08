module Octopress
  module Docs
    class DocsSiteHook < Octopress::Hooks::Site
      def post_read(site)
        if Octopress::Docs.docs_mode && Octopress.site.nil?
          Octopress.site = site
        end
      end
      
      def pre_render(site)
        if Octopress::Docs.docs_mode
          site.pages.concat Octopress::Docs.pages
        end
      end

      def merge_payload(payload, site)
        if Octopress::Docs.docs_mode
          Octopress::Docs.pages_info
        end
      end
    end
  end
end
