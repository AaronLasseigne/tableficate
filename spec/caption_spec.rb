require 'spec_helper'

describe Tableficate::Caption do
  describe '#value' do
    context '#initialize is passed the contents as a String' do
      it 'should accept plain text in the arguments' do
        described_class.new('Foo').value.should == 'Foo'
      end
    end

    context '#initialize is passed the contents as a block' do
      it 'returns the value from the block' do
        caption = described_class.new do
          'Foo'
        end

        caption.value.should == 'Foo'
      end

      it 'does not escape HTML in block output' do
        caption = described_class.new do
          '<b>Foo</b>'
        end

        ERB::Util::html_escape(caption.value).should == '<b>Foo</b>'
      end

      it 'allows template tags in block output' do
        caption = described_class.new do
          ERB.new("<%= 'Foo'.upcase %>").result(binding)
        end

        caption.value.should == 'FOO'
      end
    end
  end
end
