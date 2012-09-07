require 'spec_helper'

describe Tableficate::Column do
  let(:column_name) { :first_name }
  before(:each) do
    @table = double('Table')
    @table.stub_chain(:rows, :current_order).and_return({field: :first_name, dir: :asc})
  end
  subject { described_class.new(@table, column_name) }

  describe '#header' do
    context 'default' do
      its(:header) { should == 'First Name' }
    end

    context '#initialize where options has :header'  do
      subject { described_class.new(@table, column_name, header: 'Given Name') }

      its(:header) { should == 'Given Name'}
    end
  end

  describe '#value(row)' do
    let(:row) { NobelPrizeWinner.find_by_first_name_and_last_name('Norman', 'Borlaug') }

    it 'calls a method on the object based on the name argument passed to #initialize' do
      subject.value(row).should == 'Norman'
    end

    context '#initialize was passed a block' do
      it 'returns the value from the block' do
        column = described_class.new(@table, :full_name) do |r|
          [r.first_name, r.last_name].join(' ')
        end

        column.value(row).should == 'Norman Borlaug'
      end

      it 'does not escape HTML in block output' do
        column = described_class.new(@table, :full_name) do |r|
          [r.first_name, r.last_name].join('<br/>')
        end

        ERB::Util::html_escape(column.value(row)).should == 'Norman<br/>Borlaug'
      end

      it 'should allow template tags in block output' do
        column = described_class.new(@table, :first_name) do |r|
          ERB.new('<%= r.first_name.upcase %>').result(binding)
        end

        column.value(row).should == 'NORMAN'
      end
    end
  end

  describe '#show_sort?' do
    context 'default' do
      its(:show_sort?) { should be_false }
    end

    context '#initialize with options where :show_sort' do
      context 'is true' do
        subject { described_class.new(@table, column_name, show_sort: true) }

        its(:show_sort?) { should be_true }
      end

      context 'is false' do
        subject { described_class.new(@table, column_name, show_sort: false) }

        its(:show_sort?) { should be_false }
      end
    end
  end

  describe '#is_sorted?(dir = nil)' do
    context 'when the column is being sorted on and dir' do
      context 'is "asc"' do
        it 'returns true' do
          subject.is_sorted?('asc').should be_true
        end
      end

      context 'is "desc"' do
        it 'returns false' do
          subject.is_sorted?('desc').should be_false
        end
      end

      context 'is not provided' do
        its(:is_sorted?) { should be_true }
      end
    end

    context 'when the column is not being sorted on' do
      subject { described_class.new(@table, :last_name) }

      its(:is_sorted?) { should be_false }
    end
  end
end
