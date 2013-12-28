require 'spec_helper'

shared_examples_for 'a caption' do
  it 'returns a caption tag' do
    expect(output).to match /\A<caption>.*<\/caption>\z/
  end

  it 'returns the text' do
    expect(output).to match /\A<caption>#{text}<\/caption>\z/
  end

  context 'with options' do
    before do
      options.merge!(id: 'id')
    end

    it 'adds the attributes' do
      expect(output).to match /<caption .*?id="id".*?>/
    end
  end
end

describe Tableficate::Caption do
  include_context 'view context'

  let(:text)    { SecureRandom.hex }
  let(:options) { {} }
  let(:output)  { caption.render }

  describe '#render(view_context, *args, &block)' do
    context 'with a block' do
      subject(:caption) do
        described_class.new(view_context, options) do
          text
        end
      end

      it_behaves_like 'a caption'
    end

    context 'with an ERB block' do
      subject(:caption) do
        described_class.new(view_context, options) do
          ERB.new("<%= text %>").result(binding)
        end
      end

      it_behaves_like 'a caption'
    end

    context 'without a block' do
      subject(:caption) do
        described_class.new(view_context, text, options)
      end

      it_behaves_like 'a caption'
    end
  end
end
