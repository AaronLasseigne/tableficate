require 'tableficate/engine'
require 'tableficate/column'
require 'tableficate/caption'
require 'tableficate/empty'
require 'tableficate/table'
require 'tableficate/helper'
require 'tableficate/version'

ActionView::Base.send(:include, Tableficate::Helper)
