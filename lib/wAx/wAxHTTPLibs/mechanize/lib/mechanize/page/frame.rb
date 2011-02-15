module WAx
module WAxHTTPLibs

class Mechanize
  class Page < WAx::WAxHTTPLibs::Mechanize::File
    # This class encapsulates a 'frame' tag.  Frame objects can be treated
    # just like Link objects.  They contain src, the link they refer to,
    # name, the name of the frame.  'src' and 'name' are aliased to 'href'
    # and 'text' respectively so that a Frame object can be treated just
    # like a Link.
    class Frame < WAx::WAxHTTPLibs::Mechanize::Link
      alias :src :href
      alias :name :text

      def initialize(node, mech, referer)
        super(node, mech, referer)
        @node = node
        @text = node['name']
        @href = node['src']
      end
    end
  end
end

end end
