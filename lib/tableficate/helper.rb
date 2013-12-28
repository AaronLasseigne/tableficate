module Tableficate
  module Helper
    def table_for(rows, options = {})
      t = Tableficate::Table.new(self, rows, options, rows.tableficate_data)
      yield(t)
      t.template.render(partial: Tableficate::Utils::template_path(t.template, 'table_for', t.theme), locals:  {table: t})
    end
  end
end
