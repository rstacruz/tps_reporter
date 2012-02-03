require 'yaml'
require 'tilt'

module TPS
  class Task
    attr_reader :name     # "Create metrics"
    attr_reader :tasks    # Array of Tasks
    attr_reader :owner
    attr_reader :pivotal_id
    attr_reader :parent

    def initialize(parent, name, data=nil)
      @name   = name
      @tasks  = Array.new
      @parent = parent

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
        if ['done', 'in progress'].include?(t)
          @status = :"#{t.gsub(' ','_')}"
        # [@rstacruz]
        elsif t =~ /^@/
          @owner = t[1..-1]
        # [pt:28394] pivotal tracker
        elsif t =~ /^pt\//
          @pivotal_id = t[3..-1]
        end
      end

      @tasks = tasks.map { |task, data| Task.new self, task, data }  if tasks

      # If any subtasks are started, then we're started as well
      if unstarted? &&
         @tasks.detect { |t| t.in_progress? || t.done? }
         @status = :in_progress
      end
    end

    def status
      # If no status is given, the task is 'done' if all it's subtasks are done.
      if !@status && tasks?
        return :done  unless tasks.any? { |t| ! t.done? }
      end

      @status || :unstarted
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

    def pivotal_url
      "https://www.pivotaltracker.com/story/show/#{pivotal_id}"  if pivotal_id
    end

    def percent
      return 1.0 if done?

      if tasks.empty?
        return in_progress? ? 0.5 : 0
      end

      tasks.inject(0) { |i, task| i + task.percent } / tasks.size
    end

    def level
      parent ? parent.level + 1 : 0
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
  end
end
