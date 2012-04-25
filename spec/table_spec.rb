require 'spec_helper'

describe Tableficate::Table do
  before(:each) do
    @template = mock('Template')
    @template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    @template.lookup_context.stub!(:exists?).and_return(true)
    @npw = NobelPrizeWinner.joins(:nobel_prizes).limit(1)
    @table = Tableficate::Table.new(@template, @npw, {}, {})
  end

  context ':param_namespace in the tableficate_data hash' do
    it 'is provided then use provided string' do
      table = Tableficate::Table.new(@template, @npw, {}, {param_namespace: 'foo'})
      table.param_namespace.should == 'foo'
    end
  end

  it 'should add a empty' do
    @table.empty('There is no data.')
    @table.empty.is_a?(Tableficate::Empty).should be true
    @table.empty.value.should == 'There is no data.'

    @table.empty do
      'No data.'
    end
    @table.empty.value.should == 'No data.'
  end

  it 'should add a caption' do
    @table.caption('Nobel Prize Winners')
    @table.caption.is_a?(Tableficate::Caption).should be true
    @table.caption.value.should == 'Nobel Prize Winners'

    @table.caption do
      'Nobel Winners'
    end
    @table.caption.value.should == 'Nobel Winners'
  end

  it 'should add a Column' do
    @table.column(:first_name)
    @table.column(:last_name)

    @table.columns.first.name.should == :first_name
    @table.columns.first.is_a?(Tableficate::Column).should be true
    @table.columns.last.name.should == :last_name
  end

  it 'should indicate that it is sortble if any column is sortable' do
    @table.column(:first_name)
    @table.show_sort?.should be false

    @table.column(:last_name, show_sort: true)
    @table.show_sort?.should be true
  end

  it 'should overwrite the column sorting unless it is provided' do
    @table.column(:first_name)
    @table.column(:last_name, show_sort: true)

    @table.columns.first.show_sort?.should be false
    @table.columns.last.show_sort?.should be true

    table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {show_sorts: true}, {})
    table.column(:first_name)
    table.column(:last_name, show_sort: false)

    table.columns.first.show_sort?.should be true
    table.columns.last.show_sort?.should be false
  end

  it 'should add an ActionColumn' do
    @table.actions do
      Action!
    end

    @table.columns.first.is_a?(Tableficate::ActionColumn).should be true
  end

  it 'should determine whether any columns are sortable' do
    @table.column(:first_name, show_sort: true)

    @table.show_sort?.should be true

    table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {show_sorts: true}, {})
    table.column(:first_name, show_sort: false)

    table.show_sort?.should be false
  end

  it 'should add an Input filter' do
    @table.filter(:first_name, label: 'First')
    @table.filter(:last_name, label: 'Last')

    @table.filters.first[1].should == :first_name
    @table.filters.last[1].should == :last_name
  end

  it 'should add a InputRange filter' do
    @table.filter_range(:first_name, label: 'First')
    @table.filter_range(:last_name, label: 'Last')

    @table.filters.first[1].should == :first_name
    @table.filters.last[1].should == :last_name
  end

  it 'should add a Select filter' do
    @table.filter(:first_name, collection: {}, label: 'First')
    @table.filter(:last_name, collection: {}, label: 'Last')

    @table.filters.first[1].should == :first_name
    @table.filters.last[1].should == :last_name
  end

  it 'should return hidden_filters' do
    @table.hidden_filters.should == []

    @table.filter(:hidden, as: :hidden, value: 1)
    @table.filter(:visible)

    @table.hidden_filters.length.should == 1
    @table.hidden_filters.first[1][:as].should == :hidden
  end

  it 'should return visible_filters' do
    @table.filters.should == []

    @table.filter(:hidden, as: :hidden, value: 1)
    @table.filter(:visible)

    @table.filters.length.should == 1
    @table.filters.first[1].should == :visible
  end
end
