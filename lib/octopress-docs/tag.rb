# For plugin authors who need to generate urls pointing to ther doc pages.

module Octopress
  module Docs
    class DocUrlTag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super
        @url = markup.strip
      end

      def render(context)
        '/' + File.join(context['page']['plugin']['docs_base_url'], @url)
      end
    end
  end
end

Liquid::Template.register_tag('doc_url', Octopress::Docs::DocUrlTag)
