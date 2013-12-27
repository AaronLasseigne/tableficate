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
  let(:template) { nil }
  let(:rows)     { nil }
  let(:options)  { {} }
  let(:data)     { {} }
  subject(:table) { described_class.new(template, rows, options, {}) }

  describe '#columns' do
    its(:columns) { should eq [] }
  end

  describe '#rows' do
    its(:rows) { should eq rows }
  end

  describe '#attrs' do
    its(:attrs) { should eq(options) }

    it 'needs more tests'
  end

  describe '#param_namespace' do
    its(:param_namespace) { should eq data[:param_namespace] }
  end

  describe '#template' do
    its(:template) { should eq template }
  end

  describe '#theme' do
    context 'default' do
      its(:theme) { should eq '' }
    end

    context '#initialize where options has :theme' do
      subject { described_class.new(template, rows, {theme: 'green'}, data) }

      its(:theme) { should eq 'green' }
    end
  end

  describe '#empty(*args)' do
    it_behaves_like 'a getter and setter returning an object', :empty, Tableficate::Empty
  end

  describe '#caption(*args)' do
    it_behaves_like 'a getter and setter returning an object', :caption, Tableficate::Caption
  end

  describe '#column(name, options = {}, &block)' do
    it 'adds a Column' do
      table.column(:first_name)

      expect(table.columns.first).to be_instance_of(Tableficate::Column)
    end
  end
end
