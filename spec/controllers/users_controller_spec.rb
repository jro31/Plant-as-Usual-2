require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create(:user, dark_mode: true) }
  before { sign_in user }
  describe 'GET #current_user_data' do
    context 'current user is signed-in' do
      it 'renders a json of current user data' do
        get :current_user_data
        expect(JSON.parse(response.body)).to eq({ 'id' => user.id, 'dark_mode' => true })
      end
    end

    context 'current user is not signed-in' do
      before { sign_out user }
      it 'is unsuccessful' do
        get :current_user_data
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PATCH #toggle_dark_mode' do
    let(:params) { { user: { dark_mode: false } } }
    context 'user is signed-in' do
      it 'updates dark_mode on user' do
        expect(user.dark_mode).to eq(true)
        patch :toggle_dark_mode, params: params
        expect(user.reload.dark_mode).to eq(false)
      end
    end

    context 'user is not signed-in' do
      before { sign_out user }
      it 'does not update dark_mode on user' do
        expect(user.dark_mode).to eq(true)
        patch :toggle_dark_mode, params: params
        expect(user.reload.dark_mode).to eq(true)
      end
    end
  end
end
