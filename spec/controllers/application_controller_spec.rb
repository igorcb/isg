require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render json: { message: 'Authorized' }
    end
  end

  describe '#authorize_request' do
    context 'when user is not found' do
      it 'returns unauthorized status' do
        request.headers['Authorization'] = 'invalid_token'
        get :index
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message in the response' do
        request.headers['Authorization'] = 'invalid_token'
        get :index
        json = response.parsed_body
        expect(json['error']).to eq('Not enough or too many segments')
      end
    end
  end
end