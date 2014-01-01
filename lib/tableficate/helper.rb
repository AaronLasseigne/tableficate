module Tableficate
  module Helper
    def table_for(elements, options = {}, &block)
      Tableficate::Table.new(self, elements, options, &block).render
    end
  end
end
