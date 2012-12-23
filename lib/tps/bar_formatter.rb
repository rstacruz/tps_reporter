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

      last_max = -1

      segs = index_segments
      segs.each_with_index do |range, i|
        sprints = range.to_a.map { |i| all_sprints[i] }
        span = range.max - range.min + 1
        w = range.min-last_max-1

        line_length = segment_width * w + inner_pad

        marker_length = segment_width * span - inner_pad

        re << [ :line, [line_length, sprints] ]
        re << [ :marker, [marker_length, sprints] ]

        last_max = range.max
      end

      # Last line
      butal = all_sprints.length - sprints.last.index - 1
      re << [ :line, segment_width * butal + inner_pad ]

      re
    end

    def label
      sprints.map(&:id).join(" ")
    end

  private

    def segment_width() 35; end
    def inner_pad() 12; end

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
