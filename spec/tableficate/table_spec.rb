require 'spec_helper'

describe Tableficate::Table do
  include_context 'view context'

  let(:options)  { {} }
  subject(:table) do
    described_class.new(view_context, [], options)
  end

  describe '#caption(*args, &block)' do
    it 'creates a new caption'
      # expect(Tableficate::Caption).to have_received(:new).once
  end

  describe '#column(name, options = {}, &block)' do
    it 'creates a new column'
  end

  describe '#empty(*args, &block)' do
    it 'creates a new empty'
  end

  describe '#render' do
    let(:output) { table.render }

    it 'outputs a table tag' do
      expect(output).to match %r{\A<table>.*</table>\z}
    end

    context 'with attributes' do
      let(:options) { {id: 'id'} }

      it 'adds attributes to the table tag' do
        expect(output).to match %r{\A<table id="id">.*</table>\z}
      end
    end

    it 'outputs a header' do
      expect(output).to match %r{<thead></thead>}
    end

    it 'outputs a body' do
      expect(output).to match %r{<tbody></tbody>}
    end
  end
end
