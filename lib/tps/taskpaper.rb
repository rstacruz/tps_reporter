# TaskPaper parser
#
#     node = TaskPaper.parse("Project:\n\t- Hello\n\t- Hi")
#
#     node.children   #=> Array of <Node>
#     node.level      #=> 1 (depth)
#
#     node.text          #=> 'do things @done'
#     node.plain_text    #=> 'do things'
#     node.tags          #=> ['@done']
#
#     node.node_type
#     node.project?
#     node.task?
#     node.note?
#
module TPS::TaskPaper
  class Node
    attr_accessor :level
    attr_accessor :node_type
    attr_accessor :text
    attr_reader :children
    attr_reader :parent

    DEFAULTS = {
      :level => 0,
      :node_type => :root,
      :text => ''
    }

    def initialize(options)
      options = DEFAULTS.merge(options)
      options.each { |k, v| instance_variable_set :"@#{k}", v }
      @children = options[:children].map { |data| Node.new data.merge(:parent => self) }
    end

    def project?
      node_type == :project
    end

    def task?
      node_type == :task
    end

    def note?
      node_type == :note
    end

    def root?
      level == 0
    end

    def parent?
      !! parent
    end

    def breadcrumbs
      (parent? ? parent.breadcrumbs : []) + [self]
    end

    TAG_REGEX = %r[(?:^|\s*)@[^\s]*(?:\([^\)]*\))?]

    # Returns text without tags
    def plain_text
      text
        .gsub(TAG_REGEX, '')
        .gsub(/\s*:\s*$/, '')
        .strip
    end

    def tags
      text.scan(TAG_REGEX).map(&:strip)
    end

    def description
      if children.length > 0
        first_child = children[0]
        return first_child.text  if first_child.note?
      end
    end

    # Returns a TaskPaper document.
    def to_s
      indent = root? ? "" : "\t"
      lines = ""
      lines << to_line_s + "\n"  unless root?
      children.each { |node| lines << node.to_s.gsub(/^/, indent) }
      lines
    end

    def to_line_s
      if project?
        "#{text}:"
      elsif task?
        "- #{text}"
      else
        "#{text}"
      end
    end

    # Returns a hash from a line
    #
    #     parse_line("\t- Hello")
    #     #=> { node_type: :task, level: 2, text: "Hello" }
    #
    def self.parse_line(line)
      node = {}

      node[:level] = line.match(/^(\t*)/) && ($1.length + 1)

      line = line.strip
      if line =~ /^\- +(.*)$/
        node[:node_type] = :task
        node[:text] = $1
      elsif line =~ /^(.*):((?:\s*#{TAG_REGEX})+)?$/m
        node[:node_type] = :project
        node[:text] = "#{$1}#{$2}"
      else
        node[:node_type] = :note
        node[:text] = line
      end

      node[:children] = Array.new
      node
    end

    def walk(&blk)
      results = []
      results << self  if yield(self)
      children.each { |node| results += node.walk(&blk) }
      results
    end
  end

  # Parses a string into a node tree.
  # Returns a node.
  #
  #     node = TaskPaper.parse("Project:\n\t- Hello\n\t- Hi")
  #
  def self.parse(string)
    lines = string.split("\n")

    root = { :node_type => :root, :level => 0, :children => [] }
    ancestry = [root]
    level = 0

    lines.each_with_index do |line, i|
      next  if line.strip == ""

      node = Node.parse_line(line)

      if node[:level] <= level  # Sibling
        ancestry[node[:level]-1][:children] << node
      elsif node[:level] == level + 1  # Child
        ancestry[level][:children] << node
        ancestry[level+1] = node
      else
        raise "Line #{i}: indentation mismatch (#{node[:level]} tabs found, expected 0..#{level+1})"
      end

      level = node[:level]
      ancestry[level] = node
    end

    Node.new(root)
  end

  def self.load_file(file)
    parse File.read(file)
  end
end
