shared_context 'view context' do
  let(:view_context) do
    Class.new { include ActionView::Helpers::TagHelper }.new
  end
end
