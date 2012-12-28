require 'spec_helper'

describe Tableficate::Empty do
  let(:content) { 'Foo' }
  before(:each) do
    @table = double('Table')
  end
  subject(:empty) { described_class.new(@table, content) }

  describe '#attrs' do
    let(:colspan_hash) { {colspan: 2} }
    before(:each) do
      @table.stub_chain(:columns, :length).and_return(2)
    end

    context 'default' do
      its(:attrs) { should eq(colspan_hash) }

      it 'adjusts :colspan for coluns added after empty is initialized' do
        @table.stub_chain(:columns, :length).and_return(3)

        expect(empty.attrs[:colspan]).to eq 3
      end
    end

    context "#initialize where attrs are passed" do
      it 'returns the atts with :colspan added' do
        attrs = {style: 'width: 200px'}
        empty = described_class.new(@table, content, attrs)

        expect(empty.attrs).to eq(attrs.merge(colspan_hash))
      end
    end
  end

  describe '#value' do
    context '#initialize is passed the contents' do
      context 'as a String' do
        it 'returns the content' do
          expect(described_class.new(@table, content).value).to eq content
        end
      end

      context 'as a block' do
        it 'returns the content from the block' do
          caption = described_class.new(@table) do
            content
          end

          expect(caption.value).to eq content
        end

        it 'does not escape HTML in block output' do
          bold_content = "<b>#{content}</b>"
          caption = described_class.new(@table) do
            bold_content
          end

          expect(ERB::Util::html_escape(caption.value)).to eq bold_content
        end

        it 'allows template tags in block output' do
          caption = described_class.new(@table) do
            ERB.new("<%= content.upcase %>").result(binding)
          end

          expect(caption.value).to eq content.upcase
        end
      end
    end
  end
end
