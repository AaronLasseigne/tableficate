require 'spec_helper'

describe Tableficate::Table do
  include_context 'view context'

  let(:output) { table.render }

  context 'display an empty message' do
    let(:message) { SecureRandom.hex }
    subject(:table) do
      described_class.new(view_context, []) do |t|
        t.empty message
      end
    end

    it 'shows the message' do
      empty_html = Tableficate::Empty.new(view_context, message).render(0)

      expect(output).to match empty_html
    end
  end

  context 'display a caption' do
    let(:message) { SecureRandom.hex }
    subject(:table) do
      described_class.new(view_context, []) do |t|
        t.caption message
      end
    end

    it 'shows the message' do
      caption_html = Tableficate::Caption.new(view_context, message).render

      expect(output).to match caption_html
    end
  end

  context 'displays elements' do
    let(:elements) do
      [
        double(id: 1, name: 'Aaron'),
        double(id: 2, name: 'Bob')
      ]
    end
    subject(:table) do
      described_class.new(view_context, elements) do |t|
        t.column :id
        t.column :name
      end
    end

    it 'outputs a header with' do
      expect(output).to match %r{
        <thead>
          <tr>
            <th>Id</th>
            <th>Name</th>
          </tr>
        </thead>
      }x
    end

    it 'outputs a body' do
      expect(output).to match %r{
        <tbody>
          <tr>
            <td>#{elements[0].id}</td>
            <td>#{elements[0].name}</td>
          </tr>
          <tr>
            <td>#{elements[1].id}</td>
            <td>#{elements[1].name}</td>
          </tr>
        </tbody>
      }x
    end
  end
end
