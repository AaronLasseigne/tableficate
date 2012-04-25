module Tableficate
  class Table
    attr_reader :columns, :rows, :attrs, :param_namespace, :template, :theme

    def initialize(template, rows, options, data)
      @template = template
      @rows     = rows

      @theme      = options.delete(:theme) || ''
      @show_sorts = options.delete(:show_sorts) || false
      @attrs      = options

      @param_namespace = data[:param_namespace]
      @field_map       = data[:field_map] || {}

      @columns = []
      @filters = []
    end

    def filters
      @filters.reject{|filter| filter[2].try(:[], :as) == :hidden || filter[2].try(:[], :type) == 'hidden'}
    end

    def hidden_filters
      @filters.
        select{|filter| filter[2].try(:[], :as) == :hidden || filter[2].try(:[], :type) == 'hidden'}.
        map{|filter| filter[1, filter.size - 1]}
    end

    def empty(*args, &block)
      if args.empty? and not block_given?
        @empty
      else
        @empty = Empty.new(self, *args, &block)
      end
    end

    def caption(*args, &block)
      if args.empty? and not block_given?
        @caption
      else
        @caption = Caption.new(*args, &block)
      end
    end

    def column(name, options = {}, &block)
      @columns.push(Column.new(self, name, options.reverse_merge(show_sort: @show_sorts), &block))
    end

    def actions(options = {}, &block)
      @columns.push(ActionColumn.new(self, options, &block))
    end

    def show_sort?
      self.columns.any?{|column| column.show_sort?}
    end

    def filter(name, options = {})
      @filters.push([:input, name, options])
    end

    def filter_range(name, options = {})
      @filters.push([:input_range, name, options])
    end
  end
end
