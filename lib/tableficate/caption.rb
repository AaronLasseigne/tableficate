module Tableficate
  class Caption
    attr_reader :attrs

    def initialize(*args)
      @content = block_given? ? Proc.new : args.shift
      @attrs   = args.first.try(:dup) || {}
    end

    def value
      if @content.is_a?(Proc)
        output = @content.call
        # REVIEW: What is the is_a check for?
        output.is_a?(ActionView::OutputBuffer) ? '' : output.try(:html_safe)
      else
        @content
      end
    end
  end
end
