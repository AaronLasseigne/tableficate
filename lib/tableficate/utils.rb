module Tableficate
  module Utils
    def self.template_path(template, partial_name, theme = '')
      file_path = File.join(['tableficate', theme, partial_name].delete_if(&:empty?))

      file_path = File.join(['tableficate', partial_name]) if !theme.empty? && !template.lookup_context.exists?(file_path, [], true)

      file_path
    end
  end
end
