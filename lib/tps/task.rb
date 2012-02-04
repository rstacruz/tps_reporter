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
        if ['done', 'ok'].include?(t)
          @status = :done
        elsif ['in_progress', '...'].include?(t)
          @status = :in_progress
        # [@rstacruz]
        elsif t =~ /^@/
          @owner = t[1..-1]
        # [pt/28394] pivotal tracker
        elsif t =~ /^pt\/(.*)$/i
          @pivotal_id = $1.strip
        elsif t =~ /^([\d\.]+)%$/
          @status = :in_progress
          @percent = $1.strip.to_f / 100
        end
      end

      @tasks = tasks.map { |task, data| Task.new self, task, data }  if tasks

      # If any subtasks are started, then we're started as well.
      if unstarted? &&
         @tasks.detect { |t| t.in_progress? || t.done? }
         @status = :in_progress
      end
    end

    def status
      # If no status is given, infer the status based on tasks.
      if !@status && tasks?
        if all_subtasks_done?
          return :done
        elsif has_started_subtasks?
          return :in_progress
        end
      end
      @status or :unstarted
      end
    end

    def all_subtasks_done?
      tasks.any? { |t| ! t.done? }
    end

    def has_started_subtasks?
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

    def pivotal_url
      "https://www.pivotaltracker.com/story/show/#{pivotal_id}"  if pivotal_id
    end

    def percent
      if done?
        1.0
      elsif @percent
        @percent
      elsif tasks?
        tasks.inject(0) { |i, task| i + task.percent } / tasks.size
      else
        in_progress? ? 0.5 : 0
      end
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
