require 'yaml'
require 'tilt'

# Common usage:
#
#     list = TPS::TaskList.new data: yaml_data
#     list = TPS::TaskList.new yaml: filename
#
#     # Returns an array of tasks.
#     task.tasks
#
#     # Metadata:
#     task.name
#     task.owner
#     task.status
#
#     task.done?
#     task.in_progress?
#
#     list.to_html
#
module TPS
  ROOT = File.expand_path('../../', __FILE__)

  require 'tps/task'
  require 'tps/task_list'

  def self.root(*a)
    File.join ROOT, *a
  end
end
