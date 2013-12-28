require 'spec_helper'

shared_examples_for 'an empty' do
  it 'returns a tr and td tag' do
    expect(output).to match /\A<tr><td>.*<\/td><\/tr>\z/
  end

  it 'returns the text' do
    expect(output).to match /\A<tr><td>#{text}<\/td><\/tr>\z/
  end

  context 'with options' do
    before do
      options.merge!(id: 'id')
    end

    it 'adds the attributes' do
      expect(output).to match /<td .*?id="id".*?>/
    end
  end

  context 'the table contains one column' do
    it 'does not add colspan to the td' do
      expect(output).to_not match /<td .*?colspan="#{colspan}".*?>/
    end
  end

  context 'there table contains more than one column' do
    let(:colspan) { 2 }

    it 'adds a colspan to the td' do
      expect(output).to match /<td .*?colspan="#{colspan}".*?>/
    end
  end
end

describe Tableficate::Empty,:focus do
  include_context 'view context'

  let(:text)    { SecureRandom.hex }
  let(:options) { {} }
  let(:colspan) { 1 }
  let(:output)  { empty.render(colspan) }

  describe '#render(view_context, *args, &block)' do
    context 'with a block' do
      subject(:empty) do
        described_class.new(view_context, options) do
          text
        end
      end

      it_behaves_like 'an empty'
    end

    context 'with an ERB block' do
      subject(:empty) do
        described_class.new(view_context, options) do
          ERB.new("<%= text %>").result(binding)
        end
      end

      it_behaves_like 'an empty'
    end

    context 'without a block' do
      subject(:empty) do
        described_class.new(view_context, text, options)
      end

      it_behaves_like 'an empty'
    end
  end
end
