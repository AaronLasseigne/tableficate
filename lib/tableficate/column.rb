module Tableficate
  class Column
    attr_reader :name, :header, :table, :header_attrs, :cell_attrs, :attrs

    def initialize(table, name, options = {}, &block)
      @table, @name, @attrs, @block = table, name, options.dup, block

      @header       = @attrs.delete(:header)       || name.to_s.titleize
      @header_attrs = @attrs.delete(:header_attrs) || {}
      @cell_attrs   = @attrs.delete(:cell_attrs)   || {}
      @show_sort    = @attrs.delete(:show_sort)    || false
    end

    def value(row)
      if @block
        output = @block.call(row)
        # REVIEW: What is the is_a check for?
        output.is_a?(ActionView::OutputBuffer) ? '' : output.try(:html_safe)
      else
        row.send(@name)
      end
    end

    def show_sort?
      @show_sort
    end

    def is_sorted?(dir = nil)
      current_order = @table.rows.current_order

      current_order[:field] == name && (dir.nil? || current_order[:dir] == dir.to_sym)
    end
  end
end
