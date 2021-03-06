require 'spec_helper'

describe Tableficate::Column do
  it 'should show the header provided or default to the column name' do
    column = Tableficate::Column.new(nil, :first_name)
    column.header.should == 'First Name'

    column = Tableficate::Column.new(nil, :first_name, header: 'Given Name')
    column.header.should == 'Given Name'
  end

  it 'should take all non-specialized options as attrs on the `col` tag' do
    column = Tableficate::Column.new(nil, :first_name, class: 'attrs')
    column.attrs.should == {class: 'attrs'}

    column = Tableficate::Column.new(nil, :first_name)
    column.attrs.should == {}
  end

  it 'should accept :header_attrs as an option' do
    column = Tableficate::Column.new(nil, :first_name, header_attrs: {class: 'header'})
    column.header_attrs.should == {class: 'header'}

    column = Tableficate::Column.new(nil, :first_name)
    column.header_attrs.should == {}
  end

  it 'should accept :cell_attrs as an option' do
    column = Tableficate::Column.new(nil, :first_name, cell_attrs: {class: 'cell'})
    column.cell_attrs.should == {class: 'cell'}
  end

  it 'should show the value from the database field if no alternative is provided' do
    row = NobelPrizeWinner.find_by_first_name('Norman')
    column = Tableficate::Column.new(nil, :first_name)

    column.value(row).should == 'Norman'
  end
  it 'should return the value provided from the block' do
    row = NobelPrizeWinner.find_by_first_name_and_last_name('Norman', 'Borlaug')
    column = Tableficate::Column.new(nil, :full_name) do |row|
      [row.first_name, row.last_name].join(' ')
    end

    column.value(row).should == 'Norman Borlaug'
  end
  it 'should not escape html in block outputs' do
    row = NobelPrizeWinner.find_by_first_name_and_last_name('Norman', 'Borlaug')
    column = Tableficate::Column.new(nil, :full_name) do |row|
      [row.first_name, row.last_name].join('<br/>')
    end

    ERB::Util::html_escape(column.value(row)).should == 'Norman<br/>Borlaug'
  end
  it 'should allow ERB tags in block outputs' do
    row = NobelPrizeWinner.find_by_first_name_and_last_name('Norman', 'Borlaug')
    column = Tableficate::Column.new(nil, :first_name) do |row|
      ERB.new("<%= row.first_name.upcase %>").result(binding)
    end

    column.value(row).should == 'NORMAN'
  end

  it 'should allow sorting to be turned on and off' do
    column = Tableficate::Column.new(nil, :first_name, show_sort: false)
    column.show_sort?.should be false

    column = Tableficate::Column.new(nil, :first_name, show_sort: true)
    column.show_sort?.should be true

    # defaults to false
    column = Tableficate::Column.new(nil, :first_name)
    column.show_sort?.should be false
  end

  it 'should indicate whether a column is sorted or not' do
    table = Tableficate::Table.new(nil, NobelPrizeWinner.limit(1), {}, {current_sort: {column: :first_name, dir: 'asc'}})

    column = Tableficate::Column.new(table, :first_name)
    column.is_sorted?('asc').should be true

    column = Tableficate::Column.new(table, :first_name)
    column.is_sorted?('desc').should be false

    column = Tableficate::Column.new(table, :first_name)
    column.is_sorted?.should be true

    column = Tableficate::Column.new(table, :last_name)
    column.is_sorted?.should be false
  end
end
