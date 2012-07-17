module Tableficate
  class Base
    extend Tableficate::Finder

    def self.scope(model = nil)
      @scope = block_given? ? yield : model.to_s.camelize.constantize
    end

    def self.default_sort(name, dir = 'asc')
      @default_sort = [name, dir]
    end

    def self.column(name, options = {})
      @sort ||= {}

      @sort[name] = options[:sort] if options[:sort].present?
    end

    def self.filter(name, options = {})
      @filter ||= {}

      @filter[name] = block_given? ? Proc.new : options.reverse_merge(column: name)
    end
  end
end
