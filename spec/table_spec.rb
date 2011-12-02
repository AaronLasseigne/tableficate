require 'spec_helper'

describe Tableficate::Table do
  before(:each) do
    template = mock('Template')
    template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
    template.lookup_context.stub!(:exists?).and_return(true)
    @table = Tableficate::Table.new(template, NobelPrizeWinner.limit(1), {}, {current_sort: {column: :first_name, dir: 'asc'}})
  end

  it 'should have the current sort if provided' do
    @table.current_sort.should == {column: :first_name, dir: 'asc'}
  end

  it 'should use the :as option or default to the table_name of the scope' do
    Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {as: 'npw'}, {}).as.should == 'npw'
    @table.as.should == 'nobel_prize_winners'
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

    @table.filters.first.name.should == :first_name
    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.last.name.should == :last_name
  end

  it 'should raise an error if an unrecognized type is passed' do
    lambda {@table.filter(:first_name, as: :foo)}.should raise_error(Tableficate::Filter::UnknownInputType)
  end

  it 'should add the Input for known types and pass through the type based on :as' do
    @table.filter(:first_name, as: :search)

    @table.filters.first.is_a?(Tableficate::Filter::Input).should be true
    @table.filters.first.options[:type].should == 'search'
  end

  it 'should add a InputRange filter' do
    @table.filter_range(:first_name, label: 'First')
    @table.filter_range(:last_name, label: 'Last')

    @table.filters.first.name.should == :first_name
    @table.filters.first.is_a?(Tableficate::Filter::InputRange).should be true
    @table.filters.last.name.should == :last_name
  end

  it 'should add a Select filter' do
    @table.filter(:first_name, collection: {}, label: 'First')
    @table.filter(:last_name, collection: {}, label: 'Last')

    @table.filters.first.name.should == :first_name
    @table.filters.first.is_a?(Tableficate::Filter::Select).should be true
    @table.filters.last.name.should == :last_name
  end
end
