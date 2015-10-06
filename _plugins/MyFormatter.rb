class Jekyll::Converters::Markdown::MyFormatter
  def initialize(config)
    require 'kramdown'
    @config = config
  rescue LoadError
    STDERR.puts 'You are missing a library required for Markdown. Please run:'
    STDERR.puts '  $ [sudo] gem install kramdown'
    raise FatalException.new("Missing dependency: kramdown")
  end

  def convert(content)


    doc = Kramdown::Document.new(content).to_html
    # doc = self.images(doc)
  end

  def images(content)
    require 'nokogiri' # gem install nokogiri
    doc = Nokogiri::HTML( content )
    nodes = doc.css "img"
    nodes.each do |item|
      label = Nokogiri::XML::Node.new "div", doc
      label['class'] = 'caption'
      label.parent = item

      p = Nokogiri::XML::Node.new "p", doc
      p.content = item['title']
      p.parent = label

      wrapper = Nokogiri::XML::Node.new "div", doc
      wrapper['class'] = 'thumbnail'

      item.add_next_sibling(wrapper)
      item.parent = wrapper
      label.parent = wrapper
    end

    doc.to_html
  end
end