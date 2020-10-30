require 'rails_helper'

describe Api::V1::RecipesController, type: :controller do
  let(:user) { create(:user, username: 'steve_the_sofa') }
  let!(:recipe) { create(:recipe, user: user, name: 'Food with food on top') }

  describe 'POST #create' do
    # COMPLETE THIS
  end

  describe 'GET #index' do
    render_views
    context 'there is one recipe' do
      before { get :index, { format: :json } }
      it 'returns 1 recipe' do
        expect(JSON.parse(response.body).count).to eq(1)
      end

      it { expect(JSON.parse(response.body)[0]['id']).to eq(recipe.id) }
      it { expect(JSON.parse(response.body)[0]['name']).to eq('Food with food on top') }
      it { expect(JSON.parse(response.body)[0]['author']['id']).to eq(user.id) }
      it { expect(JSON.parse(response.body)[0]['author']['username']).to eq('steve_the_sofa') }
    end

    context 'there are multiple recipes' do
      let(:user_2) { create(:user, username: 'larry_the_lamp') }
      let!(:recipe_2) { create(:recipe, user: user_2, name: 'Banana') }
      let!(:invalid_recipe) { create(:recipe, state: :incomplete) }
      before { get :index, { format: :json } }
      it 'returns 2 recipes' do
        expect(JSON.parse(response.body).count).to eq(2)
      end

      it { expect(JSON.parse(response.body)[0]['id']).to eq(recipe.id).or(eq(recipe_2.id)) }
      it { expect(JSON.parse(response.body)[0]['name']).to eq('Food with food on top').or(eq('Banana')) }
      it { expect(JSON.parse(response.body)[0]['author']['id']).to eq(user.id).or(eq(user_2.id)) }
      it { expect(JSON.parse(response.body)[0]['author']['username']).to eq('steve_the_sofa').or(eq('larry_the_lamp')) }

      it { expect(JSON.parse(response.body)[1]['id']).to eq(recipe.id).or(eq(recipe_2.id)) }
      it { expect(JSON.parse(response.body)[1]['name']).to eq('Food with food on top').or(eq('Banana')) }
      it { expect(JSON.parse(response.body)[1]['author']['id']).to eq(user.id).or(eq(user_2.id)) }
      it { expect(JSON.parse(response.body)[1]['author']['username']).to eq('steve_the_sofa').or(eq('larry_the_lamp')) }
    end
  end

  describe 'GET #show' do
    # COMPLETE THIS
  end

  describe 'PATCH #update' do
    # COMPLETE THIS
  end

  describe 'DELETE #destroy' do
    # COMPLETE THIS
  end
end
