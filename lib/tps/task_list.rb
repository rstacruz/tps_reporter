module TPS
  # The root node.
  class TaskList < Task
    attr_accessor :tasks
    attr_accessor :sprints

    def initialize(options)
      super nil, nil, nil, nil

      data = if options[:yaml]
               YAML::load_file options[:yaml]
             elsif options[:data]
               options[:data]
             else
              options
             end

      sprint_data = data.delete('Sprints') || {}
      @sprints = Hash[*sprint_data.map { |id, name| [id, Sprint.new(id, name, self)] }.flatten]

      @tasks = data.map { |task, data| Task.new nil, task, data, self }
    end

    def sprints?
      sprints.any?
    end

    # Returns a fresh ID. (internal)
    def get_id
      @task_count ||= 0
      @task_count += 1
    end
  end
end
