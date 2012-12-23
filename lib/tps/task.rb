require 'yaml'
require 'tilt'

module TPS
  class Task
    attr_reader :name     # "Create metrics"
    attr_reader :tasks    # Array of Tasks
    attr_reader :owner
    attr_reader :pivotal_id
    attr_reader :trello_id
    attr_reader :parent
    attr_reader :tags
    attr_reader :list     # the root TaskList
    attr_reader :id

    def initialize(parent, name, data=nil, list)
      @name   = name
      @tasks  = Array.new
      @tags   = Array.new
      @parent = parent
      @list   = list

      if data.is_a?(Array)
        tags = data
        tasks = nil
      elsif data.is_a?(Hash) && data['_']
        tags = data.delete('_')
        tasks = data
      else
        tags = Array.new
        tasks = data
      end

      # Parse tags.
      tags.each do |t|
        # [done]
        if ['done', 'ok'].include?(t)
          @status = :done
        elsif ['in progress', '...'].include?(t)
          @status = :in_progress
        # [@rstacruz]
        elsif t =~ /^@/
          @owner = t[1..-1]
        # [pt/28394] -- Pivotal tracker
        elsif t =~ /^pt\/(.*)$/i
          @pivotal_id = $1.strip
        # [tl/28394] -- Trello
        elsif t =~ /^tr\/(.*)$/i
          @trello_id = $1.strip
        # [50%] -- percentage
        elsif t =~ /^([\d\.]+)%$/
          @status = :in_progress
          @percent = $1.strip.to_f / 100
        # [0pt] -- points
        elsif t =~ /^([\d\.]+)pts?/i
          @points = $1.strip.to_f
        # [-all] -- tags
        elsif %w[- #].include?(t[0])
          @tags.push t[1..-1]
        # Sprint name
        elsif list && list.sprints[t]
          @sprint = list.sprints[t]
        end
      end

      @tasks = tasks.map { |task, data| Task.new self, task, data, self.list }  if tasks

      @milestone = root? && is_milestone?(@name)

      @id = list.get_id  if list
    end

    def status
      # If no status is given, infer the status based on tasks.
      if !@status && tasks?
        if all_tasks_done?
          return :done
        elsif has_started_tasks?
          return :in_progress
        end
      end

      @status or :unstarted
    end

    def points
      if @points
        @points
      elsif tasks?
        tasks.inject(0.0) { |pts, task| pts + task.points }
      else
        1.0
      end
    end

    def points_done
      points * percent
    end

    def all_tasks_done?
      tasks? and !tasks.any? { |t| ! t.done? }
    end

    def has_started_tasks?
      tasks? and tasks.any? { |t| t.in_progress? or t.done? }
    end

    def to_s
      name
    end

    def done?
      status == :done
    end

    def in_progress?
      status == :in_progress
    end

    def unstarted?
      status == :unstarted
    end

    def tasks?
      tasks.any?
    end

    def sprint?
      !! sprint
    end

    def sprint
      @sprint || (parent && parent.sprint)
    end

    def contains_sprint?(sprint)
      contains? { |t| t.sprint == sprint }
    end

    # Filters a task list by tasks that match a given block, preserving its
    # ancestors even if they don't match.
    #
    #     @list.contains? { |t| t.done? }
    #     @list.contains? { |t| t.sprint == sprint }
    #
    def contains?(&blk)
      blk.call(self) || tasks.detect { |t| t.contains?(&blk) }
    end

    def ancestor?(&blk)
      blk.call(self) || parent && parent.ancestor?(&blk)
    end

    # Filters a task tree to tasks of a given criteria, preserving its
    # ancestors even if they don't match.
    #
    #     @list.filter { |t| t.done? }
    #
    def filter(&blk)
      filter_by { |t| t.contains?(&blk) || t.ancestor?(&blk) }
    end

    # Returns a list of a task's ancestors, excluding the list.
    def breadcrumbs(include_self=true)
      arr = []
      arr += [self]  if include_self
      arr = parent.breadcrumbs + arr  if parent
      arr
    end

    def css_class
      [
        "level-#{level}",
        "status-#{status}",
        (tasks? ? 'parent' : 'leaf'),
        ('root' if root?),
        ('feature' if feature?),
        ('milestone' if milestone?),
        ('subtask' if subtask?),
        ("sprint-#{sprint.slug}" if sprint?),
        sprint_css_classes,
        breadcrumbs(false).map { |t| "in_task_#{t.id}" }
      ].flatten.compact.join(' ')
    end

    def sprint_css_classes
      list.sprints.values.map { |sprint|
        "has_sprint-#{sprint.slug}"  if contains_sprint?(sprint)
      }.compact
    end

    def subtask?
      !feature? && !milestone?
    end

    def filter_by_sprint(sprint)
      filter { |t| t.sprint == sprint }
    end

    # Works like #filter, but only preserves ancestors if they match.
    def filter_by(&blk)
      return nil  unless blk.call(self)
      task = self.dup
      task.instance_variable_set :@tasks, tasks.map { |t| t.filter_by(&blk) }.compact
      task
    end

    def pivotal_url
      "https://www.pivotaltracker.com/story/show/#{pivotal_id}"  if pivotal_id
    end

    # Looks up a task.
    #
    #     @list['Login']
    #
    def [](name)
      tasks.detect { |t| t.name == name }
    end

    def trello_url
      if trello_id
        id = trello_id.match(/([A-Za-z0-9]+)$/) && $1.strip
        if list.trello_board_url && id.match(/^[0-9]+/)
          "#{list.trello_board_url}/#{id}"
        else
          "https://trello.com/c/#{id}"
        end
      end
    end

    def percent
      if done?
        1.0
      elsif @percent
        @percent
      elsif tasks?
        total = tasks.inject(0.0) { |pts, task| pts + task.points }
        tasks.inject(0) { |i, task| i + task.points_done } / total
      else
        in_progress? ? 0.5 : 0
      end
    end

    def level
      parent ? parent.level + 1 : 0
    end

    def root?
      ! parent
    end

    def feature?
      root? or parent.milestone?
    end

    def milestone?
      !! @milestone
    end

    def leaf?
      tasks.empty?
    end

    # - list.walk do |task, recurse|
    #   %ul
    #     %li
    #       = task
    #       - recurse.call  if recurse
    def walk(&blk)
      tasks.each do |task|
        yield task, lambda {
          task.walk { |t, recurse| blk.call t, recurse }
        }
      end
    end

    def to_html(template=nil)
      require 'tilt'
      template ||= TPS.root('data', 'index.haml')

      tpl = Tilt.new(template)
      tpl.evaluate({}, list: self)
    end

    def inspekt
      [
        root? ? "__Root__" : name,
        ("(%ipt)" % [points]),
        ("- %s" % [sprint.id]  if sprint?)
      ].compact.join(" ")
    end

    # Returns it as a simple markdown string. Great for tests.
    #
    def to_markdown
      str = " - #{inspekt}"

      if tasks?
        str += "\n" + tasks.map { |t| t.to_markdown.gsub(/^/, "  ") }.join("\n")
      end

      str
    end

  private

    def is_milestone?(str)
      str = str.to_s.downcase
      str.match(/^milestone|milestone$/i) ||
        str.match(/^release|release$/i) ||
        str.match(/^version|version$/i)
    end
  end
end
