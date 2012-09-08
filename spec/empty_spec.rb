require 'spec_helper'

describe Tableficate::Empty do
  before(:each) do
    @table = double('Table')
  end

  describe '#attrs' do
    it 'adds a :colspan based on the number of columns' do
      empty = described_class.new(@table, 'Foo')

      # Columns may be added after empty is initialized.
      @table.stub_chain(:columns, :length).and_return(2)
      
      empty.attrs[:colspan].should == 2
    end
  end

  describe '#value' do
    context '#initialize is passed the contents as a String' do
      it 'should accept plain text in the arguments' do
        described_class.new(@table, 'Foo').value.should == 'Foo'
      end
    end

    context '#initialize is passed the contents as a block' do
      it 'returns the value from the block' do
        caption = described_class.new(@table) do
          'Foo'
        end

        caption.value.should == 'Foo'
      end

      it 'does not escape HTML in block output' do
        caption = described_class.new(@table) do
          '<b>Foo</b>'
        end

        ERB::Util::html_escape(caption.value).should == '<b>Foo</b>'
      end

      it 'allows template tags in block output' do
        caption = described_class.new(@table) do
          ERB.new("<%= 'Foo'.upcase %>").result(binding)
        end

        caption.value.should == 'FOO'
      end
    end
  end
end
