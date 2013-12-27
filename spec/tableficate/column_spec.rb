require 'spec_helper'

describe Tableficate::Column do
  let(:view_context) do
    Class.new { include ActionView::Helpers::TagHelper }.new
  end
  let(:name) { :created_at }
  let(:options) { {} }
  subject(:column) do
    described_class.new(view_context, name, options)
  end

  describe '#render_header_cell' do
    let(:output) { column.render_header_cell }

    it 'returns a th' do
      expect(output).to match /\A<th>.*<\/th>\z/
    end

    context 'header text' do
      context 'is generated from the :name' do
        it 'titleizes the :name' do
          expect(output).to match />Created At</
        end
      end

      context 'is manually set' do
        let(:header_name) { 'Header Name' }
        before { options.merge!(header: header_name) }

        it 'uses the manually set header' do
          expect(output).to match />#{header_name}</
        end
      end
    end

    context 'header attributes' do
      before do
        options.merge!(header_attrs: {id: 'id', class: 'class'})
      end

      it 'adds the attributes to the th tag' do
        expect(output).to match /<th .*?id="id".*?>/
        expect(output).to match /<th .*?class="class".*?>/
      end
    end
  end

  describe '#render_row_cell(item)' do
    let(:item) { double(created_at: Time.now) }
    let(:output) { column.render_row_cell(item) }

    it 'returns a td' do
      expect(output).to match /\A<td>.*<\/td>\z/
    end

    context 'cell text' do
      it 'returns the value of the :name method on the item' do
        expect(output).to match /\A<td>#{item.created_at}<\/td>\z/
      end

      context 'given a block' do
        context 'that returns a string' do
          subject(:column) do
            described_class.new(view_context, name, options) do |item|
              item.created_at.to_date
            end
          end

          it 'fills in the td' do
            expect(output).to match />#{item.created_at.to_date}</
          end
        end

        context 'that returns ERB' do
          subject(:column) do
            described_class.new(view_context, name, options) do |item|
              ERB.new("<%= item.created_at.to_date %>").result(binding)
            end
          end

          it 'fills in the td' do
            expect(output).to match />#{item.created_at.to_date}</
          end
        end
      end

      it 'returns the value of the block given the item' do
        # needs to be with and without ERB
      end
    end

    context 'cell attributes' do
      before do
        options.merge!(cell_attrs: {id: 'id', class: 'class'})
      end

      it 'adds the attributes to the td tag' do
        expect(output).to match /<td .*?id="id".*?>/
        expect(output).to match /<td .*?class="class".*?>/
      end
    end
  end
end
