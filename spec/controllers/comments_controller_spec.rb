require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:post_comment) { create(:post, title: 'Test Title', text: 'Test Text') }
  let(:comment) { create(:comment, name: 'Test Name', comment: 'Test Comment') }
  let(:valid_attributes) { { name: 'Test Name', comment: 'Test Comment', post_id: post_comment.id } }
  let(:invalid_attributes) { { name: '', comment: '', post_id: post_comment.id } }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new comment' do
        expect {
          post :create, params: { comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it 'renders a JSON response with the new comment' do 
        post :create, params: { comment: valid_attributes  }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new comment' do
        post :create, params: { comment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested comment' do
        put :update, params: { id: comment.to_param, comment: { name: 'Updated Name' }  }
        comment.reload
        expect(comment.name).to eq('Updated Name')
      end

      it 'renders a JSON response with the comment' do
        put :update, params: { id: comment.to_param, comment: { name: 'Lorem ipsum' }  }

        json = response.parsed_body
        expect(response).to have_http_status(:ok)
        expect(json["name"]).to eq("Lorem ipsum")
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the comment' do
        put :update, params: { id: comment.to_param, comment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment_destroy) { create(:comment, name: 'Test Name Destroy', comment: 'Test Comment') }

    it 'destroys the requested comment' do
      expect {
        delete :destroy, params: { id: comment_destroy.id }
      }.to change(Comment, :count).by(-1)
    
      expect(response).to have_http_status(:no_content)
    end
  end
end