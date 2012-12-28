require 'spec_helper'

describe Tableficate::ActionColumn do
  subject(:action_column) { described_class.new(nil) }

  its(:show_sort?) { should be_false }
  its(:is_sorted?) { should be_false }
  its(:name)       { should eq '' }
end
