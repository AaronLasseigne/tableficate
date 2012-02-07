require 'spec_helper'

describe Tableficate::Finder do
  context '#tableficate(params, options = {})' do
    context 'single value filtered' do
      it 'works where the match is :exact' do
        npw = NobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {first_name: 'Albert'}}})
        npw.size.should == 1
        npw.first.first_name.should == 'Albert'
        npw = NobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {first_name: 'Al'}}})
        npw.size.should == 0
      end

      it 'works where the match is :contains' do
        class ContainsNobelPrizeWinner < Tableficate::Base
          scope :nobel_prize_winner

          filter(:first_name, match: :contains)
        end
        npw = ContainsNobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {first_name: 'Al'}}})
        npw.size.should == 1
        npw.first.first_name.should == 'Albert'
      end
    end

    context 'multiple values filtered' do
      it 'works where the match is :exact' do
        npw = NobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {first_name: ['Albert', 'Marie']}}})
        npw.size.should == 2
        npw.first.first_name.should == 'Albert'
        npw.last.first_name.should == 'Marie'
        npw = NobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {first_name: ['Al', 'Mar']}}})
        npw.size.should == 0
      end

      it 'works where the match is :contains' do
        class ContainsNobelPrizeWinner < Tableficate::Base
          scope :nobel_prize_winner

          filter(:first_name, match: :contains)
        end
        npw = ContainsNobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {first_name: ['Al', 'Mar']}}})
        npw.size.should == 2
        npw.first.first_name.should == 'Albert'
        npw.last.first_name.should == 'Marie'
      end
    end

    it 'should allow ranged input filters' do
      np = NobelPrize.tableficate({nobel_prizes: {filter: {year: {start: 1900, stop: 1930}}}})
      np.size.should == 4
    end

    it 'should remove harmful characters from the param name' do
      np = NobelPrize.tableficate({nobel_prizes: {filter: {"ye'ar" =>  {start: 1900, stop: 1930}}}})
      np.size.should == 4
    end

    it 'should handle a date string being used against a datetime or timestamp column' do
      npw = NobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {created_at: '20110101'}}})
      npw.size.should == 1
    end

    it 'should handle a date range being used against a datetime or timestamp column' do
      npw = NobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {created_at: {start: '20110101', stop: '20110105'}}}})
      npw.size.should == 5
    end

    it 'should match an exact datetime and account for the timezone setting' do
      npw = NobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {created_at: '20110101050112'}}})
      npw.size.should == 1
    end

    it 'should match an exact datetime range and account for the timezone setting' do
      npw = NobelPrizeWinner.tableficate({nobel_prize_winners: {filter: {created_at: {start: '20110101050112', stop: '20110102050212'}}}})
      npw.size.should == 2
    end

    context 'the :param_namespace option is provided' do
      it 'sets :param_namespace in the attached tableficate_data hash' do
        npw = NobelPrizeWinner.tableficate({}, {param_namespace: :foo})
        npw.tableficate_data[:param_namespace].should == 'foo'
      end
    end
    context 'the :param_namespace option is not provided' do
      it 'defauls to the primary table name' do
        npw = NobelPrizeWinner.tableficate({})
        npw.tableficate_data[:param_namespace].should == 'nobel_prize_winners'
      end
    end
  end
end
