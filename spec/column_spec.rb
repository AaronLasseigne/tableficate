require 'spec_helper'

shared_examples_for 'accepts HTML tag attributes' do |attr_type|
  context 'default' do
    its(attr_type) { should eq({}) }
  end

  context "#initialize where options has :#{attr_type}" do
    let(:attrs) { {style: 'width: 200px'} }
    subject { described_class.new(@table, name, attr_type => attrs) }

    its(attr_type) { should eq(attrs) }
  end
end

describe Tableficate::Column do
  let(:name) { :first_name }
  before(:each) do
    @table = double('Table')
    @table.stub_chain(:rows, :current_order).and_return({
      field: :first_name,
      dir:   :asc
    })
  end
  subject(:column) { described_class.new(@table, name) }

  describe '#name' do
    its(:name) { should eq name }
  end

  describe '#header' do
    context 'default' do
      its(:header) { should eq 'First Name' }
    end

    context '#initialize where options has :header'  do
      let(:header) { 'Given Name' }
      subject { described_class.new(@table, name, header: header) }

      its(:header) { should eq header }
    end
  end

  describe '#table' do
    its(:table) { should eq @table }
  end

  describe '#header_attrs' do
    it_should_behave_like 'accepts HTML tag attributes', :header_attrs
  end

  describe '#cell_attrs' do
    it_should_behave_like 'accepts HTML tag attributes', :cell_attrs
  end

  describe '#attrs' do
    context 'default' do
      its(:attrs) { should eq({}) }
    end

    context '#initialize where options are passed'  do
      it 'needs tests'
    end
  end

  describe '#value(row)' do
    let(:row) { NobelPrizeWinner.find_by_first_name_and_last_name('Norman', 'Borlaug') }

    it 'calls a method on the object based on the name argument passed to #initialize' do
      expect(column.value(row)).to eq 'Norman'
    end

    context '#initialize was passed a block' do
      it 'returns the content from the block' do
        column = described_class.new(@table, :full_name) do |r|
          [r.first_name, r.last_name].join(' ')
        end

        expect(column.value(row)).to eq 'Norman Borlaug'
      end

      it 'does not escape HTML in block output' do
        column = described_class.new(@table, :full_name) do |r|
          [r.first_name, r.last_name].join('<br/>')
        end

        expect(ERB::Util::html_escape(column.value(row))).to eq 'Norman<br/>Borlaug'
      end

      it 'allows template tags in block output' do
        column = described_class.new(@table, :first_name) do |r|
          ERB.new('<%= r.first_name.upcase %>').result(binding)
        end

        expect(column.value(row)).to eq 'NORMAN'
      end
    end
  end

  describe '#show_sort?' do
    context 'default' do
      its(:show_sort?) { should be_false }
    end

    context '#initialize with options where :show_sort' do
      context 'is true' do
        subject { described_class.new(@table, name, show_sort: true) }

        its(:show_sort?) { should be_true }
      end

      context 'is false' do
        subject { described_class.new(@table, name, show_sort: false) }

        its(:show_sort?) { should be_false }
      end
    end
  end

  describe '#is_sorted?(dir = nil)' do
    context 'when the column is being sorted on and dir' do
      context 'is "asc"' do
        it 'returns true' do
          expect(column.is_sorted?('asc')).to be_true
        end
      end

      context 'is "desc"' do
        it 'returns false' do
          expect(column.is_sorted?('desc')).to be_false
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
