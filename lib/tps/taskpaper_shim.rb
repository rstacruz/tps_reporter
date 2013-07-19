# Converts a TaskPaper document to the internal format (as represented by
# YAML).
#
#     hash = TaskPaperShim.load('file.taskpaper')
#     hash = TaskPaperShim.parse("Version 1:\n\t- Login")
#
module TPS::TaskPaperShim
  extend self

  SETTINGS = ['Trello URL']

  def parse(source)
    node = TPS::TaskPaper.parse(source)

    hash = work(node)
    hash
  end

  def work(node)
    return nil if node.tags.empty? && node.children.empty?
    hash = {}

    # Load tags
    tags = node.tags.map { |s| s.gsub(/^@/, '').gsub(/_/, ' ').gsub(/\(.*?\)$/, '') }
    if tags.any?
      if node.children.any?
        hash['_'] = tags
      else
        return tags
      end
    end

    # Load children
    node.children.each do |child|
      text = child.plain_text

      # For "Trello URL: xxx" settings
      if is_setting?(child)
        child.plain_text =~ /^(.*?): (.*)$/
        hash[$1] = $2

      # For "s1: Sprint 1" notes
      elsif node.plain_text == "Sprints"
        text.match(/^(.*?): (.*)$/) && hash[$1] = $2

      # For everything else
      elsif !child.note?
        hash[text] = work(child)
      end
    end

    hash
  end

  # Checks if a given node is a settings node
  def is_setting?(node)
    if node.note?
      SETTINGS.any? { |tag| node.plain_text =~ /^#{tag}:/ }
    end
  end

  def load(file)
    data = File.read(file)
    parse data
  end
end
