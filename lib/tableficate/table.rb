module Tableficate
  class Table
    attr_reader :columns, :rows, :attrs, :param_namespace, :template, :theme

    def initialize(template, rows, options, data)
      @template, @rows, @attrs = template, rows, options.dup

      @param_namespace = data[:param_namespace]
      @field_map       = data[:field_map] || {}

      @columns = []
    end

    def empty(*args)
      if block_given?
        @empty = Empty.new(self, *args, Proc.new)
      elsif args.length > 0
        @empty = Empty.new(self, *args)
      else
        @empty
      end
    end

    def caption(*args)
      if block_given?
        @caption = Caption.new(*args, Proc.new)
      elsif args.length > 0
        @caption = Caption.new(*args)
      else
        @caption
      end
    end

    def column(name, options = {}, &block)
      @columns.push(
        Column.new(self, name, {show_sort: @show_sorts}.merge(options), &block)
      )
    end
  end
end
