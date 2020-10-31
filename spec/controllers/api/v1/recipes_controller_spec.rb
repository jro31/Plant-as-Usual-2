require 'rails_helper'

describe Api::V1::RecipesController, type: :controller do
  let(:user) { create(:user, username: 'steve_the_sofa', twitter_handle: 'cushiondiaries', instagram_handle: 'coffeetableselfies', website_url: 'www.dontsitonme.com') }
  let(:recipe) { create(:recipe, user: user, name: 'Food with food on top', process: 'Put all the food into a bowl of food, mix well, then top with food') }
  let!(:ingredient_1) { create(:ingredient, recipe: recipe, amount: 'Some', unit: nil, food: 'Green leaves', preparation: 'Shredded', optional: false) }
  let!(:ingredient_2) { create(:ingredient, recipe: recipe, amount: '100', unit: 'grams', food: 'Bountiful fruit', preparation: nil, optional: true) }
  let!(:ingredient_3) { create(:ingredient, recipe: recipe, amount: '', unit: '', food: 'Fanciful loot', preparation: '', optional: false) }
  let(:test_photo) { fixture_file_upload(Rails.root.join('public', 'test-photo.jpg'), 'image/jpg') }

  describe 'POST #create' do
    render_views
    context 'user exists' do
      let(:headers) { { 'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token } }
      let(:params) { { recipe: { name: 'Jam salad', process: 'Mix jam with lettuce leaves and tomatoes', photo: test_photo, ingredients_attributes: [ ingredient_1_params, ingredient_2_params, ingredient_3_params ] } } }
      let(:ingredient_1_params) { { amount: '1', unit: 'jar', food: 'Jam', preparation: 'mashed', optional: false } }
      let(:ingredient_2_params) { { amount: '1', unit: nil, food: 'Iceberg lettuce', preparation: 'Chopped', optional: false } }
      let(:ingredient_3_params) { { amount: nil, unit: nil, food: 'Tomatoes', preparation: nil, optional: true } }
      before { request.headers.merge!(headers) }

      context 'no ingredients' do
        context 'recipe is valid' do
          context 'includes photo' do
            let(:params) { { recipe: { name: 'Karma sandwich', process: 'Reap the karma and eat with ketchup', photo: test_photo } } }

            it 'creates a recipe' do
              expect { post :create, params: params, format: :json }.to change(Recipe, :count).by(1)
            end

            it 'gives the recipe the correct details' do
              post :create, params: params, format: :json
              expect(Recipe.last.id).to be_present
              expect(Recipe.last.user).to eq(user)
              expect(Recipe.last.name).to eq('Karma sandwich')
              expect(Recipe.last.process).to eq('Reap the karma and eat with ketchup')
              expect(Recipe.last.photo.url).to include('test-photo.jpg')
              expect(Recipe.last.photo.thumb.url).to include('test-photo.jpg')
              expect(Recipe.last.photo.max_height_350.url).to include('test-photo.jpg')
              expect(Recipe.last.photo.max_height_500.url).to include('test-photo.jpg')
              expect(Recipe.last.photo.max_height_720.url).to include('test-photo.jpg')
              expect(Recipe.last.photo.max_height_1000.url).to include('test-photo.jpg')
              expect(Recipe.last.photo.max_width_500.url).to include('test-photo.jpg')
              expect(Recipe.last.photo.max_width_1000.url).to include('test-photo.jpg')
              expect(Recipe.last.state).to eq('incomplete')
            end

            it 'does not create any ingredients' do
              expect { post :create, params: params, format: :json }.to change(Ingredient, :count).by(0)
            end

            it 'returns the new recipe' do
              post :create, params: params, format: :json
              expect(JSON.parse(response.body)['id']).to eq(Recipe.last.id)
              expect(JSON.parse(response.body)['name']).to eq('Karma sandwich')
              expect(JSON.parse(response.body)['process']).to eq('Reap the karma and eat with ketchup')
              expect(JSON.parse(response.body)['photo']['url']).to include('test-photo.jpg')
              expect(JSON.parse(response.body)['photo']['thumb']['url']).to include('test-photo.jpg')
              expect(JSON.parse(response.body)['photo']['max_height_350']['url']).to include('test-photo.jpg')
              expect(JSON.parse(response.body)['photo']['max_height_500']['url']).to include('test-photo.jpg')
              expect(JSON.parse(response.body)['photo']['max_height_720']['url']).to include('test-photo.jpg')
              expect(JSON.parse(response.body)['photo']['max_height_1000']['url']).to include('test-photo.jpg')
              expect(JSON.parse(response.body)['photo']['max_width_500']['url']).to include('test-photo.jpg')
              expect(JSON.parse(response.body)['photo']['max_width_1000']['url']).to include('test-photo.jpg')
              expect(JSON.parse(response.body)['ingredients']).to eq([])
              expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
              expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
              expect(JSON.parse(response.body)['author']['twitter_handle']).to eq('cushiondiaries')
              expect(JSON.parse(response.body)['author']['instagram_username']).to eq('coffeetableselfies')
              expect(JSON.parse(response.body)['author']['website']).to eq('www.dontsitonme.com')
            end
          end

          context 'does not include photo' do
            let(:params) { { recipe: { name: 'Curry of Greatness', process: 'Mix your greatness with curry powder and cumin' } } }

            it 'creates a recipe' do
              expect { post :create, params: params, format: :json }.to change(Recipe, :count).by(1)
            end
              # expect(Recipe.last.photo.file.exists?).to eq(true)
          end
        end

        context 'recipe is not valid' do

        end
      end

      context 'one ingredient' do

      end

      context 'many ingredients' do

      end
    end

    context 'user does not exist' do

    end
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

    context 'there are no recipes' do
      let!(:recipe) { nil }
      let!(:ingredient_1) { nil }
      let!(:ingredient_2) { nil }
      let!(:ingredient_3) { nil }
      before { get :index, { format: :json } }
      it 'returns 0 recipes' do
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'returns an empty array' do
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe 'GET #show' do
    render_views
    context 'recipe exists' do
      context 'it has no ingredients' do
        # COMPLETE THIS
      end

      context 'it has one ingredient' do
        let(:user) { create(:user, username: 'steve_the_sofa', twitter_handle: nil, instagram_handle: nil, website_url: nil) }
        let!(:ingredient_2) { nil }
        let!(:ingredient_3) { nil }
        before { get :show, params: { id: recipe.id, format: :json } }
        it { expect(JSON.parse(response.body)['id']).to eq(recipe.id) }
        it { expect(JSON.parse(response.body)['name']).to eq('Food with food on top') }
        it { expect(JSON.parse(response.body)['process']).to eq('Put all the food into a bowl of food, mix well, then top with food') }

        it { expect(JSON.parse(response.body)['ingredients'].count).to eq(1) }

        it { expect(JSON.parse(response.body)['ingredients'][0]['id']).to eq(ingredient_1.id) }
        it { expect(JSON.parse(response.body)['ingredients'][0]['recipe_id']).to eq(recipe.id) }
        it { expect(JSON.parse(response.body)['ingredients'][0]['amount']).to eq('Some') }
        it { expect(JSON.parse(response.body)['ingredients'][0]['unit']).to eq(nil) }
        it { expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Green leaves') }
        it { expect(JSON.parse(response.body)['ingredients'][0]['preparation']).to eq('Shredded') }
        it { expect(JSON.parse(response.body)['ingredients'][0]['optional']).to eq(false) }

        it { expect(JSON.parse(response.body)['author']['id']).to eq(user.id) }
        it { expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa') }
        it { expect(JSON.parse(response.body)['author']['twitter_handle']).to eq(nil) }
        it { expect(JSON.parse(response.body)['author']['instagram_username']).to eq(nil) }
        it { expect(JSON.parse(response.body)['author']['website']).to eq(nil) }
      end

      context 'it has many ingredients' do
        before { get :show, params: { id: recipe.id, format: :json } }
        it { expect(JSON.parse(response.body)['id']).to eq(recipe.id) }
        it { expect(JSON.parse(response.body)['name']).to eq('Food with food on top') }
        it { expect(JSON.parse(response.body)['process']).to eq('Put all the food into a bowl of food, mix well, then top with food') }

        it { expect(JSON.parse(response.body)['ingredients'].count).to eq(3) }

        it { expect(JSON.parse(response.body)['ingredients'][0]['id']).to eq(ingredient_1.id).or(eq(ingredient_2.id)).or(eq(ingredient_3.id)) }
        it { expect(JSON.parse(response.body)['ingredients'][0]['recipe_id']).to eq(recipe.id) }
        it { expect(JSON.parse(response.body)['ingredients'][0]['amount']).to eq('Some').or(eq('100')).or(eq('')) }
        it { expect(JSON.parse(response.body)['ingredients'][0]['unit']).to eq(nil).or(eq('grams')).or(eq('')) }
        it { expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot')) }
        it { expect(JSON.parse(response.body)['ingredients'][0]['preparation']).to eq('Shredded').or(eq(nil)).or(eq('')) }
        it { expect(JSON.parse(response.body)['ingredients'][0]['optional']).to eq(false).or(eq(true)) }

        it { expect(JSON.parse(response.body)['ingredients'][1]['id']).to eq(ingredient_1.id).or(eq(ingredient_2.id)).or(eq(ingredient_3.id)) }
        it { expect(JSON.parse(response.body)['ingredients'][1]['recipe_id']).to eq(recipe.id) }
        it { expect(JSON.parse(response.body)['ingredients'][1]['amount']).to eq('Some').or(eq('100')).or(eq('')) }
        it { expect(JSON.parse(response.body)['ingredients'][1]['unit']).to eq(nil).or(eq('grams')).or(eq('')) }
        it { expect(JSON.parse(response.body)['ingredients'][1]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot')) }
        it { expect(JSON.parse(response.body)['ingredients'][1]['preparation']).to eq('Shredded').or(eq(nil)).or(eq('')) }
        it { expect(JSON.parse(response.body)['ingredients'][1]['optional']).to eq(false).or(eq(true)) }

        it { expect(JSON.parse(response.body)['ingredients'][2]['id']).to eq(ingredient_1.id).or(eq(ingredient_2.id)).or(eq(ingredient_3.id)) }
        it { expect(JSON.parse(response.body)['ingredients'][2]['recipe_id']).to eq(recipe.id) }
        it { expect(JSON.parse(response.body)['ingredients'][2]['amount']).to eq('Some').or(eq('100')).or(eq('')) }
        it { expect(JSON.parse(response.body)['ingredients'][2]['unit']).to eq(nil).or(eq('grams')).or(eq('')) }
        it { expect(JSON.parse(response.body)['ingredients'][2]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot')) }
        it { expect(JSON.parse(response.body)['ingredients'][2]['preparation']).to eq('Shredded').or(eq(nil)).or(eq('')) }
        it { expect(JSON.parse(response.body)['ingredients'][2]['optional']).to eq(false).or(eq(true)) }

        it { expect(JSON.parse(response.body)['author']['id']).to eq(user.id) }
        it { expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa') }
        it { expect(JSON.parse(response.body)['author']['twitter_handle']).to eq('cushiondiaries') }
        it { expect(JSON.parse(response.body)['author']['instagram_username']).to eq('coffeetableselfies') }
        it { expect(JSON.parse(response.body)['author']['website']).to eq('www.dontsitonme.com') }
      end
    end

    context 'recipe does not exist' do
      before { get :show, params: { id: 9999, format: :json } }
      it { expect(JSON.parse(response.body)).to eq({'error' => "Couldn't find Recipe with 'id'=9999"}) }
    end
  end

  describe 'PATCH #update' do
    # COMPLETE THIS
  end

  describe 'DELETE #destroy' do
    # COMPLETE THIS
  end
end
