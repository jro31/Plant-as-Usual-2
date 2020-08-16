require 'rails_helper'

describe PagesController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'GET #home' do
    context 'user is signed-in' do
      it 'returns http success' do
        get :home
        expect(response).to be_successful
      end
    end

    context 'user is not signed-in' do
      it 'returns http success' do
        sign_out user
        get :home
        expect(response).to be_successful
      end
    end
  end
end
