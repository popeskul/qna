require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    it 'call Services::Search#search_by' do
      expect(Services::Search).to receive(:search_by).with('Query', 'Type')
      get :index, params: { query: 'Query', type: 'Type' }
    end

    it 'renders index view' do
      get :index, params: { query: 'Query', type: 'Type' }
      expect(response).to render_template :index
    end
  end
end
