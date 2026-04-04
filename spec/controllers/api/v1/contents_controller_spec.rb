require 'rails_helper'

RSpec.describe Api::V1::ContentsController, type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:content) { create(:content, user: user) }

  let(:headers) do
    token = JsonWebToken.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}" }
  end

  let(:other_headers) do
    token = JsonWebToken.encode(user_id: other_user.id)
    { 'Authorization' => "Bearer #{token}" }
  end

  let(:valid_params) do
    {
      title: 'Test Title',
      body: 'Test Body'
    }
  end

  describe 'GET /index' do
    before do
      create_list(:content, 2, user: user)
      get '/api/v1/content'
    end

    it 'returns all contents' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data'].length).to eq(3)
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      before do
        post '/api/v1/contents', params: valid_params, headers: headers
      end

      it 'creates content' do
        expect(response).to have_http_status(:created)
        expect(Content.count).to eq(2)
      end
    end

    context 'with invalid params' do
      context 'when title is blank' do
        before do
          post '/api/v1/contents', params: { title: '', body: 'This is Body' }, headers: headers
        end

        it 'returns errors' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to have_key('error')
          expect(JSON.parse(response.body)['error']).to include("Title can't be blank")
        end
      end

      context 'when body is blank' do
        before do
          post '/api/v1/contents', params: { title: 'This is title', body: '' }, headers: headers
        end

        it 'returns errors' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to have_key('error')
          expect(JSON.parse(response.body)['error']).to include("Body can't be blank")
        end
      end
    end

    context 'without authentication' do
      before do
        post '/api/v1/contents', params: valid_params
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /update' do
    context 'when user is not authenticated' do
      before do
        put "/api/v1/contents/#{content.id}", params: valid_params
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when owner updates content' do
      before do
        put "/api/v1/contents/#{content.id}", params: { title: 'Updated Title', body: 'Updated Body' }, headers: headers
      end

      it 'updates content' do
        expect(response).to have_http_status(:ok)
        expect(content.reload.title).to eq('Updated Title')
        expect(content.reload.body).to eq('Updated Body')
      end
    end

    context 'when not owner' do
      before do
        put "/api/v1/contents/#{content.id}", params: valid_params, headers: other_headers
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['error']).to eq('You are not authorized to perform this action')
      end
    end

    context 'when content not found' do
      before do
        put "/api/v1/contents/999", params: valid_params, headers: headers
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when user is not authenticated' do
      before do
        delete "/api/v1/contents/#{content.id}"
      end

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when owner deletes content' do
      before do
        delete "/api/v1/contents/#{content.id}", headers: headers
      end

      it 'deletes content' do
        expect(response).to have_http_status(:ok)
        expect(Content.exists?(content.id)).to be_falsey
      end
    end

    context 'when not owner' do
      before do
        delete "/api/v1/contents/#{content.id}", headers: other_headers
      end

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['error']).to eq('You are not authorized to perform this action')
      end
    end

    context 'when content not found' do
      before do
        delete "/api/v1/contents/999", headers: headers
      end

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
