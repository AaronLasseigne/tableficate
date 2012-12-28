require 'spec_helper'

shared_examples_for 'tableficate_data' do
  it 'adds and retreives data from the scope' do
    subject.tableficate_data = {}
    subject.tableficate_data[:name] = 'Aaron'

    expect(subject.tableficate_data).to eq({name: 'Aaron'})
  end
end

describe 'Tableficate::ActiveRecordExtention' do
  describe '.tableficate_ext' do
    subject { NobelPrizeWinner.tableficate_ext }

    it_should_behave_like 'tableficate_data'

    describe '.to_a' do
      subject { NobelPrizeWinner.tableficate_ext.to_a }

      it_should_behave_like 'tableficate_data'
    end
  end
end
