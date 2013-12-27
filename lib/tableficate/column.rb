module Tableficate
  class Column
    def initialize(view_context, name, options = {}, &block)
      @view_context, @name, @attrs, @block = view_context, name, options.dup, block

      @header       = @attrs.delete(:header)       || name.to_s.titleize
      @header_attrs = @attrs.delete(:header_attrs) || {}
      @cell_attrs   = @attrs.delete(:cell_attrs)   || {}
    end

    def render_header_cell
      @view_context.content_tag(:th, @header, @header_attrs)
    end

    def render_row_cell(item)
      @view_context.content_tag(:td, cell_text(item), @cell_attrs)
    end

    private

    def cell_text(item)
      if @block
        @block.call(item)
      else
        item.send(@name)
      end
    end
  end
end
