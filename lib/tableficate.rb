require 'action_view'

require 'tableficate/version'
require 'tableficate/engine' if defined?(::Rails)

require 'tableficate/column'
require 'tableficate/caption'
require 'tableficate/empty'
require 'tableficate/table'
require 'tableficate/helper'

ActiveSupport.on_load(:action_view) do
  include Tableficate::Helper
end
