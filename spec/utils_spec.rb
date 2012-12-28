require 'spec_helper'

describe Tableficate::Utils do
  describe ".template_path(template, partial_name, theme = '')" do
    before(:each) do
      @template = double('Template')
    end

    context 'theme' do
      context 'is blank' do
        it 'returns a path' do
          @template.stub_chain(:lookup_context, :exists?).and_return(true)

          expect(Tableficate::Utils::template_path(@template, 'table')).to eq 'tableficate/table'
        end
      end

      context 'is not blank' do
        it 'returns a path with the theme' do
          @template.stub_chain(:lookup_context, :exists?).and_return(true)

          expect(Tableficate::Utils::template_path(@template, 'table', 'futuristic')).to eq 'tableficate/futuristic/table'
        end

        context 'has no matching partial' do
          it 'falls back to a path with no theme' do
            @template.stub!(:lookup_context).and_return(ActionView::LookupContext.new([]))
            @template.lookup_context.should_receive(:exists?) do |*args|
              (args.first == 'tableficate/table')
            end

            expect(Tableficate::Utils::template_path(@template, 'table', 'futuristic')).to eq 'tableficate/table'
          end
        end
      end
    end
  end
end
