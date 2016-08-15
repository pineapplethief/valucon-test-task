RSpec.describe Web::Dashboard::BaseController, type: :controller do
  describe 'dashboard requires authentication by default' do
    it { is_expected.to use_before_filter(:authenticate_user!) }
  end
end
