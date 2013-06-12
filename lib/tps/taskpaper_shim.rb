module TPS::TaskPaperShim
  extend self

  def convert(source)
    node = TPS::TaskPaper.parse(source)

    hash = work(node)
    hash
  end

  def work(node)
    return nil if node.note?
    return nil if node.tags.empty? && node.children.empty?
    hash = {}

    tags = node.tags.map { |s| s.gsub(/^@/, '').gsub(/_/, ' ') }
    if tags.any?
      if node.children.any?
        hash['_'] = tags
      else
        return tags
      end
    end

    node.children.each do |child|
      text = child.plain_text
      if node.plain_text == "Sprints"
        text.match(/^(.*?): (.*)$/) && hash[$1] = $2
      else
        hash[text] = work(child)
      end
    end

    hash
  end

  def load(file)
    data = File.read(file)
    convert data
  end
end
