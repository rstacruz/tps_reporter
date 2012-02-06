module TPS
  class CliReporter
    attr_reader :task

    def initialize(task)
      @task = task
    end

    def print
      puts report
    end

    def report
      re = ""
      task.walk do |t, recurse|
        re += CliReporter.new(t).report_task
        recurse.call  if recurse
      end
      re
    end

    def report_task
      indent = ' ' * (4 * task.level)

      # Columns
      c1 = "%s %s %s" % [ indent, status, task.name ]
      c2 = if task.feature? || task.milestone?
             "%6s %s" % [ points, progress ]
          else
            ' '*19
          end

      pref = c("-"*80, 30)+"\n"  if task.feature?

      # Put together
      "#{pref}" + "%-88s%s\n" % [ c1, c2 ]
    end

    def points
      [
        "%3i" % [ task.points_done ],
        c("/", 30),
        c("%-2i" % [ task.points ], 32)
      ].join ''
    end

    def color
      if task.done?
        32
      elsif task.in_progress?
        34
      else
        30
      end
    end

    def status
      l = c("(", 30)
      r = c(")", 30)
      if task.done?
         l + c('##', color) + r
      elsif task.in_progress?
        l + c('--', color) + r
      else
        l + c('  ', color) + r
      end
    end

    def progress
      max = 12
      len = (task.percent * max).to_i

      prog = ("%-#{max}s" % ["="*len])
      prog = c("|"*len, color) + c("."*(max-len), 30)

      prog
    end

  private
    def c(str, c=nil)
      c ? "\033[#{c}m#{str}\033[0m" : str
    end
  end
end
