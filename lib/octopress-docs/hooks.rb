module Octopress
  module Docs
    class DocsSiteHook < Octopress::Hooks::Site
      def post_init(site)
        if ENV['OCTOPRESS_DOCS'] && Octopress.site.nil?
          Octopress.site = site
        end
      end

      def post_read(site)
        if ENV['OCTOPRESS_DOCS']
          site.pages.concat Octopress::Docs.pages
        end
      end

      def merge_payload(payload, site)
        if ENV['OCTOPRESS_DOCS']
          Octopress::Docs.pages_info
        end
      end
    end
  end
end
