module TPS
  # Presenter for tasks to format things into bars.
  class BarFormatter
    attr_reader :task

    def initialize(task)
      @task = task
    end

    # Array of sprints.
    def sprints
      @sprints ||= task.sprints
    end

    def all_sprints
      @all_sprints ||= @task.list.sprints.values
    end

    # Returns segments of the indices of sprints.
    def index_segments
      to_segments(sprints.map(&:index))
    end

    def visible?
      sprints.any?
    end

    # Returns segments. Lines are in the format:
    #
    #     |type, (size, sprints)|
    #
    def segments
      re = Array.new

      last_max = 0

      segs = index_segments
      segs.each_with_index do |range, i|
        sprints = range.to_a.map { |i| all_sprints[i] }
        span = range.max - range.min + 1
        w = range.min-last_max-1

        re << [ :line, [left_pad + segment_width * w, sprints] ]
        re << [ :marker, [segment_width * span, sprints] ]

        last_max = range.max
      end

      re
    end

    def label
      sprints.map(&:id).join(" ")
    end

  private

    def segment_width() 35; end
    def left_pad() 6; end

    # Connects an array of numeric indices. Returns an array of ranges.
    #
    #     to_segments([2,3,4,5,6,14,15])
    #     #=> [ (2..6), (14..15) ]
    #
    def to_segments(indexes)
      segments = Array.new

      ([-1] + indexes).each_cons(2) do |prev, i|
        if prev == -1
          segments << (i..i)
          prev = i-1
        end
        if prev.next == i
          segments[segments.length-1] = ((segments[segments.length-1].min)..i)
        else
          segments << (i..i)
        end
      end

      segments
    end

  end
end
