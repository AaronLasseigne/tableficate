module Tableficate
  class Table
    FILTER_TYPE    = 0
    FILTER_NAME    = 1
    FILTER_OPTIONS = 2

    attr_reader :columns, :rows, :attrs, :param_namespace, :template, :theme

    def initialize(template, rows, options, data)
      @template, @rows, @attrs = template, rows, options.dup

      @theme      = @attrs.delete(:theme) || ''
      @show_sorts = @attrs.delete(:show_sorts) || false

      @param_namespace = data[:param_namespace]
      @field_map       = data[:field_map] || {}

      @columns = @filters = []
    end

    def filters
      @filters.reject { |filter| hidden_filter?(filter) }
    end

    def hidden_filters
      @filters.
        select { |filter| hidden_filter?(filter) }.
        map { |filter| filter[FILTER_NAME, 2] }
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
      @columns.push(Column.new(self, name, {show_sort: @show_sorts}.merge(options), &block))
    end

    def actions(options = {}, &block)
      @columns.push(ActionColumn.new(self, options, &block))
    end

    def show_sort?
      self.columns.any?(&:show_sort?)
    end

    def filter(name, options = {})
      @filters.push([:input, name, options])
    end

    def filter_range(name, options = {})
      @filters.push([:input_range, name, options])
    end

    private

    def hidden_filter?(filter)
      filter[FILTER_OPTIONS][:as].to_s == 'hidden'
    end
  end
end
