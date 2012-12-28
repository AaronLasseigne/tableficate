require 'spec_helper'

shared_examples 'a getter and setter returning an object' do |method, klass|
  context 'has args' do
    it 'acts as a setter' do
      subject.send(method, 'Foo')

      expect(subject.send(method)).to be_instance_of(klass)
    end
  end

  context 'has a block' do
    it 'acts as a setter' do
      subject.send(method, Proc.new { 'Foo' })

      expect(subject.send(method)).to be_instance_of(klass)
    end
  end

  context 'has no args and no block' do
    it 'acts as a getter' do
      subject.send(method, 'Foo')

      expect(subject.send(method)).to be_instance_of(klass)
    end
  end
end

describe Tableficate::Table do
  let(:template) { nil }
  let(:rows)     { nil }
  let(:options)  { {} }
  let(:data)     { {} }
  subject(:table) { described_class.new(template, rows, options, {}) }

  describe '#columns' do
    its(:columns) { should eq [] }
  end

  describe '#rows' do
    its(:rows) { should eq rows }
  end

  describe '#attrs' do
    its(:attrs) { should eq(options) }

    it 'needs more tests'
  end

  describe '#param_namespace' do
    its(:param_namespace) { should eq data[:param_namespace] }
  end

  describe '#template' do
    its(:template) { should eq template }
  end

  describe '#theme' do
    context 'defualt' do
      its(:theme) { should eq '' }
    end

    context '#initialize where options has :theme' do
      subject { described_class.new(template, rows, {theme: 'green'}, data) }

      its(:theme) { should eq 'green' }
    end
  end

  describe '#filters' do
    it 'returns all filters not of the :type "hidden"' do
      filter_type_index = 1
      table.filter(:hidden, as: :hidden, value: 1)
      table.filter(:visible)

      expect(table.filters).to have(1).filter
      expect(table.filters.first[filter_type_index]).to eq :visible
    end
  end

  describe '#hidden_filters' do
    it 'returns all filters of the :type "hidden"' do
      filter_type_index = 0
      table.filter(:hidden, as: :hidden, value: 1)
      table.filter(:visible)

      expect(table.hidden_filters).to have(1).filter
      expect(table.hidden_filters.first[filter_type_index]).to eq :hidden
    end
  end

  describe '#empty(*args)' do
    it_behaves_like 'a getter and setter returning an object', :empty, Tableficate::Empty
  end

  describe '#caption(*args)' do
    it_behaves_like 'a getter and setter returning an object', :caption, Tableficate::Caption
  end

  describe '#column(name, options = {}, &block)' do
    it 'adds a Column' do
      table.column(:first_name)

      expect(table.columns.first).to be_instance_of(Tableficate::Column)
    end

    it 'defaults the sorting to false' do
      table.column(:first_name)

      expect(table.columns.first.show_sort?).to be_false
    end

    context 'options' do
      context 'has :show_sort' do
        it 'uses the provided value' do
          table.column(:first_name, show_sort: true)

          expect(table.columns.first.show_sort?).to be_true
        end
      end

      context 'has no :show_sort' do
        it 'defaults to :show_sorts on the table' do
          table = described_class.new(template, rows, {show_sorts: true}, {})
          table.column(:first_name)

          expect(table.columns.first.show_sort?).to be_true
        end
      end
    end
  end

  describe '#actions(options = {}, &block)' do
    it 'adds an ActionColumn' do
      table.actions do
        'Action!'
      end

      expect(table.columns.first).to be_instance_of(Tableficate::ActionColumn)
    end
  end

  describe '#show_sort?' do
    context 'any column is sortable' do
      it 'returns true' do
        table.column(:last_name, {show_sort: true})

        expect(table.show_sort?).to be_true
      end
    end

    context 'no column is sortable' do
      its(:show_sort?) { should be_false }
    end
  end

  describe '#filter(name, options = {})' do
    it 'adds an Input filter' do
      table.filter(:first_name)

      expect(table.filters.first).to eq [:input, :first_name, {}]
    end
  end

  describe '#filter_range(name, options = {})' do
    it 'adds a InputRange filter' do
      table.filter_range(:first_name)

      expect(table.filters.first).to eq [:input_range, :first_name, {}]
    end
  end
end
