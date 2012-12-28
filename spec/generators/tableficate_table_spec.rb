require 'spec_helper'
require 'genspec'

describe 'tableficate:table' do
  with_args :foo do
    it 'generates app/tables/foo.rb' do
      expect(subject).to generate('app/tables/foo.rb') { |content|
        expect(content).to match /class Foo < Tableficate\:\:Base/
      }
    end
  end

  with_args :foo, :bar do
    it 'generates app/tables/foo.rb with a scope' do
      expect(subject).to generate('app/tables/foo.rb') { |content|
        expect(content).to match /scope \:bar/
      }
    end
  end

  with_args :foo, 'NobelPrizeWinner' do
    it 'generates app/tables/foo.rb with a scope based on the model' do
      expect(subject).to generate('app/tables/foo.rb') { |content|
        expect(content).to match /scope \:nobel_prize_winner/
      }
    end
  end
end
