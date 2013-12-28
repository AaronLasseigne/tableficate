module Tableficate
  class Caption
    def initialize(view_context, *args)
      @view_context = view_context

      @message = block_given? ? Proc.new.call : args.shift
      @attrs   = args.first.try(:dup) || {}
    end

    def render
      @view_context.content_tag(:caption, @message, @attrs)
    end
  end
end
