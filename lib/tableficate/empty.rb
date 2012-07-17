module Tableficate
  class Empty
    def initialize(table, *args)
      @table   = table
      @content = block_given? ? Proc.new : args.shift
      @attrs   = args.first || {}
    end

    def value
      if @content.is_a?(String)
        @content
      else
        output = @content.call
        if output.is_a?(ActionView::OutputBuffer)
          ''
        else
          output = output.html_safe if output.respond_to? :html_safe
          output
        end
      end
    end

    def attrs
      @attrs[:colspan] = @table.columns.length
      @attrs
    end
  end
end
