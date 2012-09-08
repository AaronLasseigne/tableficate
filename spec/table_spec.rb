require 'spec_helper'

shared_examples 'a getter and setter returning an object' do |method, klass|
  context 'has args' do
    it 'acts as a setter' do
      subject.send(method, 'Foo')

      subject.send(method).should be_instance_of(klass)
    end
  end

  context 'has a block' do
    it 'acts as a setter' do
      subject.send(method, Proc.new { 'Foo' })

      subject.send(method).should be_instance_of(klass)
    end
  end

  context 'has no args and no block' do
    it 'acts as a getter' do
      subject.send(method, 'Foo')

      subject.send(method).should be_instance_of(klass)
    end
  end
end

describe Tableficate::Table do
  let(:template) { nil }
  let(:rows)     { nil }
  subject { described_class.new(template, rows, {}, {}) }

  describe '#filters' do
    it 'returns all filters not of the :type "hidden"' do
      subject.filter(:hidden, as: :hidden, value: 1)
      subject.filter(:visible)

      subject.filters.should have(1).filter
      subject.filters.first[1].should == :visible
    end
  end

  describe '#hidden_filters' do
    it 'returns all filters of the :type "hidden"' do
      subject.filter(:hidden, as: :hidden, value: 1)
      subject.filter(:visible)

      subject.hidden_filters.should have(1).filter
      subject.hidden_filters.first[0].should == :hidden
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
      subject.column(:first_name)

      subject.columns.first.should be_instance_of(Tableficate::Column)
    end

    context 'options' do
      context 'has no :show_sort' do
        it 'defaults to :show_sorts on the table' do
          table = described_class.new(template, rows, {show_sorts: true}, {})
          table.column(:first_name)

          table.columns.first.show_sort?.should be_true
        end
      end
    end
  end

  describe '#actions(options = {}, &block)' do
    it 'adds an ActionColumn' do
      subject.actions do
        'Action!'
      end

      subject.columns.first.should be_instance_of(Tableficate::ActionColumn)
    end
  end

  describe '#show_sort?' do
    before(:each) do
      subject.column(:first_name)
    end

    context 'any column is sortable' do
      it 'returns true' do
        subject.column(:last_name, {show_sort: true})

        subject.show_sort?.should be_true
      end
    end

    context 'no column is sortable' do
      its(:show_sort?) { should be_false }
    end
  end

  describe '#filter(name, options = {})' do
    it 'adds an Input filter' do
      subject.filter(:first_name)

      subject.filters.first.should == [:input, :first_name, {}]
    end
  end

  describe '#filter_range(name, options = {})' do
    it 'adds a InputRange filter' do
      subject.filter_range(:first_name)

      subject.filters.first.should == [:input_range, :first_name, {}]
    end
  end
end
