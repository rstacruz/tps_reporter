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
  end
end
