module Tableficate
  class ActionColumn < Column
    def initialize(table, options = {}, &block)
      super(table, '', options, &block)
    end
  end
end
