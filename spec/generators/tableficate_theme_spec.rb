require 'spec_helper'
require 'genspec'

describe 'tableficate:theme' do
  with_args :foo do
    it 'generates app/views/tableficate/foo/ with all files' do
      expect(subject).to generate('app/views/tableficate/foo')
      expect(subject).to generate('app/views/tableficate/foo/_table.html.erb')
    end
  end

  with_args :foo, 'table_for' do
    it 'generates a single file in app/views/tableficate/foo/' do
      expect(subject).to generate('app/views/tableficate/foo')
      expect(subject).to generate('app/views/tableficate/foo/_table_for.html.erb')
    end
  end
end
