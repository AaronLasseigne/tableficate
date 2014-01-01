require 'spec_helper'

shared_examples 'a getter and setter returning an object' do |method, klass|
  context 'has args' do
    it 'acts as a setter' do
      subject.send(method, 'Foo')

      expect(subject.send(method)).to be_instance_of(klass)
    end
  end

  context 'has a block' do
    it 'acts as a setter' do
      subject.send(method, Proc.new { 'Foo' })

      expect(subject.send(method)).to be_instance_of(klass)
    end
  end

  context 'has no args and no block' do
    it 'acts as a getter' do
      subject.send(method, 'Foo')

      expect(subject.send(method)).to be_instance_of(klass)
    end
  end
end

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
