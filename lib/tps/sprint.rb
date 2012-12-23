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
      sublist ? sublist.points_for(self) : 0.0
    end

    def points_done
      sublist ? sublist.points_done : 0.0
    end

    def percent
      sublist ? sublist.percent : 0.0
    end

    def sublist
      @sublist ||= list.filter_by_sprint(self)
    end

    def slug
      slugify id
    end

    def inspect
      '#<%s %s ("%s")>' % [ self.class.name, id, name ]
    end

    def to_s
      inspect
    end

  private

    def slugify(str)
      str.scan(/[A-Za-z0-9]+/).join('_').downcase
    end
  end
end
