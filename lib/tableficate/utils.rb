module Tableficate
  module Utils
    def self.template_path(template, partial_name, theme = '')
      file_path = File.join(['tableficate', theme, partial_name].delete_if(&:empty?))

      # We have a theme but no matching partial so we fall back to the default partial.
      if !theme.empty? && !template.lookup_context.exists?(file_path, [], true)
        file_path = File.join(['tableficate', partial_name])
      end

      file_path
    end
  end
end
