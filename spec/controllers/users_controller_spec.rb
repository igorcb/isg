require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user, name: 'John Doe', email: 'john@example.com', password: 'password', password_confirmation: 'password' ) }
  let(:valid_attributes) { { name: 'John Doe', email: 'john@example.com', password: 'password', password_confirmation: 'password' } }
  let(:invalid_attributes) { { name: '', email: '', password: '', password_confirmation: 'password' } }

  describe 'GET #show' do
    let(:user) { User.create(name: 'John Doe', email: 'john@example.com', password: 'password', password_confirmation: 'password') }
    before { request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id) }
    
    it 'returns a success response' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user details' do
      get :show, params: { id: user.id }
      user_response = JSON.parse(response.body)
      expect(user_response['id']).to eq(user.id)
      expect(user_response['name']).to eq(user.name)
      expect(user_response['email']).to eq(user.email)
    end

    it 'returns not_found status when the user does not exist' do
      get :show, params: { id: 99_999 }
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error message when the user does not exist' do
      get :show, params: { id: 99_999 }
      json = response.parsed_body
      expect(json['error']).to eq('User not found')
    end
  end
  
  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post :create, params: { user: valid_attributes }
        
        json = response.parsed_body
        expect(response).to have_http_status(:created)
        expect(json['name']).to eq('John Doe')
        expect(json['email']).to eq('john@example.com')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new user' do
        post :create, params: { user: invalid_attributes }

        json = response.parsed_body
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['name']).to include("can't be blank")
        expect(json['email']).to include("can't be blank")
        expect(json['email']).to include('is invalid')
        expect(json['password']).to include("can't be blank")
        expect(json['password']).to include('is too short (minimum is 6 characters)')
        expect(json['password_confirmation']).to include("doesn't match Password")
      end
    end
  end

  describe 'PUT #update' do
    let(:valid_attributes_update) { { name: 'Jane Doe'} }
    before { request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id) }

    context 'with valid params' do
      it 'updates the requested user' do
        put :update, params: { id: user.to_param, user: valid_attributes_update }
        user.reload
        expect(user.name).to eq('Jane Doe')
      end

      it 'renders a JSON response with the user' do
        put :update, params: { id: user.to_param, user: valid_attributes }
        expect(response).to have_http_status(:ok)
      end

      it 'returns not_found status when the user does not exist' do
        put :update, params: { id: 99_999, user: valid_attributes_update }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message when the user does not exist' do
        put :update, params: { id: 99_999, user: { name: 'New Name', email: 'new_email@example.com' } }
        json = response.parsed_body
        expect(json['error']).to eq('User not found')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the user' do
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user_destroy) { User.create(name: 'John Doe', email: 'john@example.com', password: 'password', password_confirmation: 'password') }
    
    before { request.headers['Authorization'] = JsonWebToken.encode(user_id: user_destroy.id) }

    it 'destroys the requested user' do
      expect {
        delete :destroy, params: { id: user_destroy.id }
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'returns not_found status when the user does not exist' do
      delete :destroy, params: { id: 99_999 }

      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error message when the user does not exist' do
      delete :destroy, params: { id: 99_999 }

      json = response.parsed_body
      expect(json['error']).to eq('User not found')
    end
  end
end
