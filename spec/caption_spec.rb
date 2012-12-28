require 'spec_helper'

describe Tableficate::Caption do
  describe '#value' do
    let(:content) { 'Foo' }

    context '#initialize is passed the contents' do
      context 'as a String' do
        it 'returns the content' do
          expect(described_class.new(content).value).to eq content
        end
      end

      context 'as a block' do
        it 'returns the content from the block' do
          caption = described_class.new do
            content
          end

          expect(caption.value).to eq content
        end

        it 'does not escape HTML in block output' do
          bold_content = "<b>#{content}</b>"
          caption = described_class.new do
            bold_content
          end

          expect(ERB::Util::html_escape(caption.value)).to eq bold_content
        end

        it 'allows template tags in block output' do
          caption = described_class.new do
            ERB.new("<%= content.upcase %>").result(binding)
          end

          expect(caption.value).to eq content.upcase
        end
      end
    end
  end
end
