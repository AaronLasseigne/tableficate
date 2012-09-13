require 'spec_helper'

describe Tableficate::Finder do
  describe '#tableficate(params, options = {})' do
    context 'single value filtered' do
      it 'works where the match is :exact' do
        npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => 'Albert'
        }}})
        npw.should have(1).record
        npw.first.first_name.should == 'Albert'

        npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => 'Al'
        }}})
        npw.should have(0).records
      end

      it 'works where the match is :contains' do
        class ContainsNobelPrizeWinner < Tableficate::Base
          scope :nobel_prize_winner

          filter(:first_name, match: :contains)
        end
        npw = ContainsNobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => 'Al'
        }}})

        npw.should have(1).record 
        npw.first.first_name.should == 'Albert'
      end
    end

    context 'multiple values filtered' do
      it 'works where the match is :exact' do
        npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => ['Albert', 'Marie']
        }}})

        npw.should have(2).records
        npw.first.first_name.should == 'Albert'
        npw.last.first_name.should == 'Marie'

        npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => ['Al', 'Mar']
        }}})
        npw.should have(0).records
      end

      it 'works where the match is :contains' do
        class ContainsNobelPrizeWinner < Tableficate::Base
          scope :nobel_prize_winner

          filter(:first_name, match: :contains)
        end
        npw = ContainsNobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => ['Al', 'Mar']
        }}})

        npw.should have(2).records
        npw.first.first_name.should == 'Albert'
        npw.last.first_name.should == 'Marie'
      end
    end

    it 'allows ranged input filters' do
      np = NobelPrize.tableficate({'nobel_prizes' => {'filter' => {
        'year' => {'start' => 1900, 'stop' => 1930}
      }}})

      np.should have(4).records
    end

    it 'handles a date string being used against a datetime or timestamp column' do
      npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
        'created_at' => '20110101'
      }}})

      npw.should have(1).record
    end

    it 'handles a date range being used against a datetime or timestamp column' do
      npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
        'created_at' => {'start' => '20110101', 'stop' => '20110105'}
      }}})

      npw.should have(5).records
    end

    it 'matchs an exact datetime and account for the timezone setting' do
      npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
        'created_at' => '20110101050112'
      }}})

      npw.should have(1).record
    end

    it 'matchs an exact datetime range and account for the timezone setting' do
      npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
        'created_at' => {'start' => '20110101050112', 'stop' => '20110102050212'}
      }}})

      npw.should have(2).records
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
