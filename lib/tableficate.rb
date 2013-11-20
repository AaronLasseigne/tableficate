require 'tableficate/engine'
require 'tableficate/utils'
require 'tableficate/column'
require 'tableficate/action_column'
require 'tableficate/caption'
require 'tableficate/empty'
require 'tableficate/table'
require 'tableficate/helper'
require 'tableficate/version'

ActionView::Base.send(:include, Tableficate::Helper)
