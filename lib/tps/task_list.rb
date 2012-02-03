module TPS
  class TaskList < Task
    def initialize(options)
      super nil, nil

      data = if options[:yaml]
               YAML::load_file options[:yaml]
             elsif options[:data]
               options[:data]
             else
              options
             end

      @tasks = data.map { |task, data| Task.new nil, task, data }
    end
  end
end
