require 'spec_helper'

describe Tableficate::Finder do
  describe '#tableficate(params, options = {})' do
    it 'raises an error if the scope does not exist' do
      class NoScope < Tableficate::Base; end
      expect { NoScope.tableficate({}) }.to raise_error(Tableficate::MissingScope)
    end

    context 'single value filtered' do
      it 'works where the match is :exact' do
        npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => 'Albert'
        }}})
        expect(npw).to have(1).record
        expect(npw.first.first_name).to eq 'Albert'

        npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => 'Al'
        }}})
        expect(npw).to have(0).records
      end

      it 'works where the match is :contains' do
        class ContainsNobelPrizeWinner < Tableficate::Base
          scope :nobel_prize_winner

          filter(:first_name, match: :contains)
        end
        npw = ContainsNobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => 'Al'
        }}})

        expect(npw).to have(1).record 
        expect(npw.first.first_name).to eq 'Albert'
      end
    end

    context 'multiple values filtered' do
      it 'works where the match is :exact' do
        npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => ['Albert', 'Marie']
        }}})

        expect(npw).to have(2).records
        expect(npw.first.first_name).to eq 'Albert'
        expect(npw.last.first_name).to eq 'Marie'

        npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => ['Al', 'Mar']
        }}})
        expect(npw).to have(0).records
      end

      it 'works where the match is :contains' do
        class ContainsNobelPrizeWinner < Tableficate::Base
          scope :nobel_prize_winner

          filter(:first_name, match: :contains)
        end
        npw = ContainsNobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
          'first_name' => ['Al', 'Mar']
        }}})

        expect(npw).to have(2).records
        expect(npw.first.first_name).to eq 'Albert'
        expect(npw.last.first_name).to eq 'Marie'
      end
    end

    it 'allows ranged input filters' do
      np = NobelPrize.tableficate({'nobel_prizes' => {'filter' => {
        'year' => {'start' => 1900, 'stop' => 1930}
      }}})

      expect(np).to have(4).records
    end

    it 'handles a date string being used against a datetime or timestamp column' do
      npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
        'created_at' => '20110101'
      }}})

      expect(npw).to have(1).record
    end

    it 'handles a date range being used against a datetime or timestamp column' do
      npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
        'created_at' => {'start' => '20110101', 'stop' => '20110105'}
      }}})

      expect(npw).to have(5).records
    end

    it 'matches an exact datetime and account for the timezone setting' do
      npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
        'created_at' => '20110101050112'
      }}})

      expect(npw).to have(1).record
    end

    it 'matches an exact datetime range and account for the timezone setting' do
      npw = NobelPrizeWinner.tableficate({'nobel_prize_winners' => {'filter' => {
        'created_at' => {'start' => '20110101050112', 'stop' => '20110102050212'}
      }}})

      expect(npw).to have(2).records
    end

    context 'the :param_namespace option is provided' do
      it 'sets :param_namespace in the attached tableficate_data hash' do
        npw = NobelPrizeWinner.tableficate({}, {param_namespace: :foo})

        expect(npw.tableficate_data[:param_namespace]).to eq 'foo'
      end
    end

    context 'the :param_namespace option is not provided' do
      it 'defauls to the primary table name' do
        npw = NobelPrizeWinner.tableficate({})

        expect(npw.tableficate_data[:param_namespace]).to eq 'nobel_prize_winners'
      end
    end
  end
end
