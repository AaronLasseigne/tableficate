require 'tablificate/engine'
require 'tablificate/column'
require 'tablificate/table'
require 'tablificate/helper'
require 'tablificate/base'
require 'tablificate/version'

ActionView::Base.send(:include, Tablificate::Helper)
