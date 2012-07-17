module Tableficate
  module Finder
    def tableficate(params, options = {})
      scope = @scope || self
      raise Tableficate::MissingScope unless scope.new.kind_of?(ActiveRecord::Base)

      scope = scope.tableficate_ext
      scope.tableficate_data = {}
      scope.tableficate_data[:param_namespace] = options[:param_namespace].try(:to_s) || scope.table_name

      # filtering
      scope = scope.with_filters(params, {
        param_namespace: "#{scope.tableficate_data[:param_namespace]}[filter]",
        fields:          @filter
      })

      # sorting
      with_order_options = {param_namespace: scope.tableficate_data[:param_namespace]}
      with_order_options[:default] = @default_sort.join('-') if @default_sort
      with_order_options[:fields] = @sort if @sort
      scope = scope.with_order(params, with_order_options)

      # return an arel object with our data attached
      filters_with_field = @filter ? @filter.select{|name, options| not options.is_a?(Proc) and options and options.key?(:field)} : {}
      scope.tableficate_data[:field_map] = Hash[filters_with_field.map{|name, options| [name, options[:field]]}]
      scope
    end
  end
end
