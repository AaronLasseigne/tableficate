module Tableficate
  class Caption
    def initialize(view_context, *args, &block)
      @view_context = view_context

      @content = block_given? ? block.call : args.shift
      @attrs   = args.first.try(:dup) || {}
    end

    def render
      @view_context.content_tag(:caption, @content, @attrs)
    end
  end
end
