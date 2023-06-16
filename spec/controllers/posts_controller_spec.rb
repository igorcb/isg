require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user, name: 'John Doe', email: 'john@example.com', password: 'password', password_confirmation: 'password' ) }
  let(:valid_attributes) { { title: 'Test Title', text: 'Test Text', user_id: user.id } }
  let(:invalid_attributes) { { title: '', text: 'Test Text', user_id: user.id } }

  before { request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id) }

  describe 'GET #show' do
    let(:post) { create(:post, title: 'Título do post', text: 'Texto do post', user_id: user.id) }

    it 'returns a success response' do
      get :show, params: { user_id: user.id, id: post.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the post details' do
      get :show, params: { user_id: user.id, id: post.id }
      post_response = JSON.parse(response.body)
      expect(post_response['id']).to eq(post.id)
      expect(post_response['title']).to eq(post.title)
      expect(post_response['text']).to eq(post.text)
      expect(post_response['user']['id']).to eq(user.id)
      expect(post_response['user']['name']).to eq(user.name)
      expect(post_response['user']['email']).to eq(user.email)
    end

    it 'returns not_found status when the user does not exist' do
      put :update, params: { user_id: 99_999, id: post.id }
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error user message in the response' do
      put :update, params: { user_id: 99_999, id: post.id }
      json = response.parsed_body
      expect(json['error']).to eq('User not found')
    end

    it 'returns not_found status when the post does not exist' do
      put :update, params: { user_id: user.id, id: 99_999 }
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error post message in the response' do
      put :update, params: { user_id: user.id, id: 99_999 }
      json = response.parsed_body
      expect(json['error']).to eq('Post not found')
    end

  end  

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Post' do
        expect {
          post :create, params: { user_id: user.id, post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it 'renders a JSON response with the new post' do
        post :create, params: { user_id: user.id, post: valid_attributes }
        
        json = response.parsed_body
        expect(response).to have_http_status(:created)
        expect(json["title"]).to eq("Test Title")
        expect(json["text"]).to eq("Test Text")
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new post' do
        post :create, params: { user_id: user.id, post: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let!(:post) { create(:post, title: 'Test Title', text: 'Test Text', user: user) }
  
    before { request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id) }

    context 'with valid params' do
      it 'updates the requested post' do
        put :update, params: { user_id: user.id, id: post.id, post: { title: 'Updated Title' } }
        post.reload
        expect(post.title).to eq('Updated Title')
      end

      it 'renders a JSON response with the post' do
        put :update, params: { user_id: user.id, id: post.id, post: { title: 'Updated Title' } }

        json = response.parsed_body
        expect(response).to have_http_status(:ok)
        expect(json["title"]).to eq("Updated Title")
      end

      it 'returns unprocessable_entity status when the user params are invalid' do
        put :update, params: { user_id: user.id, id: post.id, post: { title: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns not_found status when the user does not exist' do
        put :update, params: { user_id: 99_999, id: post.id, post: { title: 'Updated Title' } }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error user message in the response' do
        put :update, params: { user_id: 99_999, id: post.id, post: { title: 'Updated Title' } }
        json = response.parsed_body
        expect(json['error']).to eq('User not found')
      end

      it 'returns not_found status when the post does not exist' do
        put :update, params: { user_id: user.id, id: 99_999, post: { title: 'Updated Title' } }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error post message in the response' do
        put :update, params: { user_id: user.id, id: 99_999, post: { title: 'Updated Title' } }
        json = response.parsed_body
        expect(json['error']).to eq('Post not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) { create(:post, title: 'Test Title', text: 'Test Text', user: user) }

    before { request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id) }

    context 'when post is not found' do
      it 'destroys the requested post' do
        expect {
          delete :destroy, params: { user_id: user.id, id: post.id }
        }.to change(Post, :count).by(-1)
  
        expect(response).to have_http_status(:no_content)
      end

      it 'returns not_found status when the user does not exist' do
        delete :destroy, params: { user_id: 99_999, id: post.id }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error user message in the response' do
        delete :destroy, params: { user_id: 99_999, id: post.id  }
        json = response.parsed_body
        expect(json['error']).to eq('User not found')
      end

      it 'returns not_found status when the post does not exist' do
        delete :destroy, params: { user_id: user.id, id: 99_999 }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error post message in the response' do
        delete :destroy, params: { user_id: user.id, id: 99_999 }
        json = response.parsed_body
        expect(json['error']).to eq('Post not found')
      end

    end
  end
end