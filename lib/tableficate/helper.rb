module Tableficate
  module Helper
    def table_for(rows, options = {})
      t = Tableficate::Table.new(self, rows, options, rows.tableficate_data)
      yield(t)
      t.template.render(partial: Tableficate::Utils::template_path(t.template, 'table_for', t.theme), locals:  {table: t})
    end

    def tableficate_table_tag(table)
      render partial: Tableficate::Utils::template_path(table.template, 'table', table.theme), locals: {table: table}
    end

    def tableficate_header_tag(column)
      table = column.table
      render partial: Tableficate::Utils::template_path(table.template, 'header', table.theme), locals: {column: column}
    end

    def tableficate_data_tag(row, column)
      table = column.table
      render partial: Tableficate::Utils::template_path(table.template, 'data', table.theme), locals: {row: row, column: column}
    end

    def tableficate_row_tag(row, columns)
      table = columns.first.table
      render partial: Tableficate::Utils::template_path(table.template, 'row', table.theme), locals: {row: row, columns: columns}
    end
  end
end
