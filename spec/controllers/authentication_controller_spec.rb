require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  let(:user) { create(:user, name: 'John Doe', email: 'john@example.com', password: 'password', password_confirmation: "password") }

  describe 'POST #login' do
    context 'with valid credentials' do
      let(:valid_credentials) { { email: user.email, password: 'password' } }

      it 'returns a JWT token' do
        post :login, params: valid_credentials

        json = response.parsed_body
        expect(JSON.parse(response.body)['token']).not_to be_nil
      end

      it 'returns a success response' do
        post :login, params: valid_credentials
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid credentials' do
      let(:invalid_credentials) { { email: user.email, password: 'wrong_password' } }

      it 'returns an error message' do
        post :login, params: invalid_credentials
        json = response.parsed_body
        expect(json['error']).to eq('User or password invalid.')
      end

      it 'returns an unauthorized status' do
        post :login, params: invalid_credentials
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
