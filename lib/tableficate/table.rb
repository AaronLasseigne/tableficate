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

    def empty(*args)
      if block_given?
        @empty = Empty.new(self, *args, Proc.new)
      elsif args.present?
        @empty = Empty.new(self, *args)
      else
        @empty
      end
    end

    def caption(*args)
      if block_given?
        @caption = Caption.new(*args, Proc.new)
      elsif args.present?
        @caption = Caption.new(*args)
      else
        @caption
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
