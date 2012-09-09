require 'spec_helper'

describe Tableficate::Base do
  describe '.scope(model = nil)' do
    # FIXME: Move this into the finder spec. That's where the error is thrown
    it 'raises an error if the model does not exist' do
      class NoScope < Tableficate::Base; end
      expect { NoScope.tableficate({}) }.to raise_error(Tableficate::MissingScope)
    end

    context 'model name given' do
      it 'finds the model' do
        class SymbolScope < Tableficate::Base
          scope :nobel_prize_winner
        end

        SymbolScope.send(:instance_variable_get, '@scope').should == NobelPrizeWinner
      end

      # REVIEW: Should this throw a MissingScope error?
      it 'raises an error if the model does not exist' do
        expect {
          class WrongScope < Tableficate::Base;
            scope :foo
          end
        }.to raise_error(NameError)
      end
    end

    context 'a block given' do
      it 'uses the scope provided in the block' do
        class BlockScope < Tableficate::Base
          scope do
            NobelPrizeWinner.joins(:nobel_prizes)
          end
        end

        BlockScope.send(:instance_variable_get, '@scope').should == NobelPrizeWinner.joins(:nobel_prizes)
      end
    end
  end

  describe ".default_sort(name, dir = 'asc')" do
    context 'where name' do
      context 'is a column with no custom sorting' do
        context 'where dir' do
          it 'is "asc"' do
            class DefaultOrder < Tableficate::Base
              scope(:nobel_prize_winner)

              default_sort(:first_name)
            end
            npw = DefaultOrder.tableficate({})

            npw.order_values.first.should == %Q(#{npw.table_name}."first_name" ASC)
          end

          it 'is "desc"' do
            class DefaultOrderDesc < Tableficate::Base
              scope(:nobel_prize_winner)

              default_sort(:first_name, 'desc')
            end
            npw = DefaultOrderDesc.tableficate({})

            npw.order_values.first.should == %Q(#{npw.table_name}."first_name" ASC)
            npw.reverse_order.should be_true
          end
        end
      end

      context 'is a column with custom sorting' do
        it 'orders by the provided sort' do
          class DefaultOrderWithOverride < Tableficate::Base
            scope(:nobel_prize_winner)

            default_sort(:full_name)

            column(:full_name, sort: 'first_name ASC, last_name ASC')
          end
          npw = DefaultOrderWithOverride.tableficate({})

          npw.order_values.first.should == 'first_name ASC, last_name ASC'
        end
      end
    end
  end

  describe '.column(name, options = {})' do
    it 'sets a custom sort for the column' do
      class ColumnOrder < Tableficate::Base
        scope(:nobel_prize_winner)
        
        column(:full_name, sort: 'first_name ASC, last_name ASC')
      end

      ColumnOrder.send(:instance_variable_get, '@sort')[:full_name].should == 'first_name ASC, last_name ASC'
    end
  end

  describe '.filter(name, options = {})' do
    context 'where options' do
      context 'has :match' do
        context 'is "contains"' do
          it 'filters a single input' do
            class FilterByContainsInput < Tableficate::Base
              scope(:nobel_prize_winner)

              filter(:first_name, match: :contains)
            end
            npw = FilterByContainsInput.tableficate({'nobel_prize_winners' => {'filter' => {'first_name' => 'Al'}}})

            npw.should have(1).record
            npw.first.first_name.should == 'Albert'
          end

          it 'filters multiple inputs' do
            class FilterByContainsInput < Tableficate::Base
              scope(:nobel_prize_winner)

              filter(:first_name, match: :contains)
            end
            npw = FilterByContainsInput.tableficate({'nobel_prize_winners' => {'filter' => {'first_name' => ['Al', 'Mar']}}})

            npw.should have(2).records
            npw.first.first_name.should == 'Albert'
            npw.last.first_name.should == 'Marie'
          end
        end
      end
    end

    it 'allows custom block filters' do
      class BlockFilter < Tableficate::Base
        scope(:nobel_prize_winner)

        filter(:full_name) do |value, scope|
          first_name, last_name = value.split(/\s+/)

          if last_name.nil?
            scope.where(['first_name LIKE ? OR last_name LIKE ?', first_name, first_name])
          else
            scope.where(['first_name LIKE ? AND last_name LIKE ?', first_name, last_name])
          end 
        end 
      end
      npw = BlockFilter.tableficate({'nobel_prize_winners' => {'filter' => {'full_name' => 'Bohr'}}})

      npw.should have(1).record
      npw.first.first_name.should == 'Niels'
    end
  end
end
