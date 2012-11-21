module TPS
  class Sprint
    attr_accessor :id
    attr_accessor :name
    attr_accessor :list

    def initialize(id, name, list)
      @id = id
      @name = name
      @list = list
    end

    # Returns the numeric index of the sprint.
    #
    #     s1.index  #=> 0
    #     s2.index  #=> 1
    #
    def index
      list.sprints.keys.index id
    end

    def points
      sublist.points
    end

    def points_done
      sublist.points_done
    end

    def percent
      sublist.percent
    end

    def sublist
      @sublist ||= list.filter_by_sprint(self)
    end
  end
end
