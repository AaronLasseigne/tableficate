module Tableficate
  class Table
    def initialize(view_context, elements, options = {}, &block)
      @view_context = view_context

      @elements, @attrs = elements, options.dup

      @columns = []

      block.call(self) if block_given?
    end

    def caption(*args, &block)
      @caption = Caption.new(@view_context, *args, &block)
    end

    def column(name, options = {}, &block)
      @columns.push(
        Column.new(@view_context, name, options, &block)
      )
    end

    def empty(*args, &block)
      @empty = Empty.new(@view_context, *args, &block)
    end

    def render
      caption_html = (@caption ? @caption.render : '').html_safe

      @view_context.content_tag(:table, caption_html + head + body, @attrs)
    end

    private

    def head
      @view_context.content_tag(:thead, tr(@columns.map(&:render_header)))
    end

    def body
      content =
        if @empty && rows.empty?
          @empty.render(@columns.size)
        else
          rows.join.html_safe
        end

      @view_context.content_tag(:tbody, content)
    end

    def rows
      @rows ||= @elements.map { |element| row(element) }
    end

    def row(element)
      tr(@columns.map { |column| column.render_cell(element) })
    end

    def tr(cells)
      @view_context.content_tag(:tr, cells.join.html_safe) if !cells.empty?
    end
  end
end
