require 'rails_helper'

describe RecipesController, type: :controller do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  before { sign_in user }

  describe 'GET #index' do
    context 'user is signed-in' do
      it 'returns http success' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'user is not signed-in' do
      it 'returns http success' do
        sign_out user
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #show' do
    context 'user is signed-in' do
      it 'returns http success' do
        get :show, params: { id: recipe.id }
        expect(response).to be_successful
      end
    end

    context 'user is not signed-in' do
      it 'returns http success' do
        sign_out user
        get :show, params: { id: recipe.id }
        expect(response).to be_successful
      end
    end
  end
end