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
    before { request.headers.merge!(headers) }
    context 'user exists' do
      let(:headers) { { 'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token } }
      let(:params) { { recipe: { name: 'Jam salad', process: 'Mix jam with lettuce leaves and tomatoes', photo: test_photo, ingredients_attributes: [ ingredient_1_params, ingredient_2_params, ingredient_3_params ] } } }
      let(:ingredient_1_params) { { amount: '1', unit: 'jar', food: 'Jam', preparation: 'mashed', optional: false } }
      let(:ingredient_2_params) { { amount: '2', unit: nil, food: 'Iceberg lettuce', preparation: 'Chopped', optional: false } }
      let(:ingredient_3_params) { { amount: nil, unit: nil, food: 'Tomatoes', preparation: nil, optional: true } }

      context 'save is successful' do
        context 'no ingredients' do
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

            it 'gives the recipe the correct details' do
              post :create, params: params, format: :json
              expect(Recipe.last.id).to be_present
              expect(Recipe.last.user).to eq(user)
              expect(Recipe.last.name).to eq('Curry of Greatness')
              expect(Recipe.last.process).to eq('Mix your greatness with curry powder and cumin')
              expect(Recipe.last.photo.url).to eq(nil)
              expect(Recipe.last.state).to eq('incomplete')
            end

            it 'returns the new recipe' do
              post :create, params: params, format: :json
              expect(JSON.parse(response.body)['id']).to eq(Recipe.last.id)
              expect(JSON.parse(response.body)['name']).to eq('Curry of Greatness')
              expect(JSON.parse(response.body)['process']).to eq('Mix your greatness with curry powder and cumin')
              expect(JSON.parse(response.body)['photo']['url']).to eq(nil)
              expect(JSON.parse(response.body)['photo']['thumb']['url']).to eq(nil)
              expect(JSON.parse(response.body)['photo']['max_height_350']['url']).to eq(nil)
              expect(JSON.parse(response.body)['photo']['max_height_500']['url']).to eq(nil)
              expect(JSON.parse(response.body)['photo']['max_height_720']['url']).to eq(nil)
              expect(JSON.parse(response.body)['photo']['max_height_1000']['url']).to eq(nil)
              expect(JSON.parse(response.body)['photo']['max_width_500']['url']).to eq(nil)
              expect(JSON.parse(response.body)['photo']['max_width_1000']['url']).to eq(nil)
              expect(JSON.parse(response.body)['ingredients']).to eq([])
              expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
              expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
              expect(JSON.parse(response.body)['author']['twitter_handle']).to eq('cushiondiaries')
              expect(JSON.parse(response.body)['author']['instagram_username']).to eq('coffeetableselfies')
              expect(JSON.parse(response.body)['author']['website']).to eq('www.dontsitonme.com')
            end
          end
        end

        context 'one ingredient' do
          let(:params) { { recipe: { name: 'Kung fu pasta', process: 'Cook spaghetti accoring to package instructions.\n\nAdd some funky Chinese sauce and feel the burn.', photo: test_photo, ingredients_attributes: [ ingredient_1_params ] } } }

          it 'creates a recipe' do
            expect { post :create, params: params, format: :json }.to change(Recipe, :count).by(1)
          end

          it 'gives the recipe the correct details' do
            post :create, params: params, format: :json
            expect(Recipe.last.id).to be_present
            expect(Recipe.last.user).to eq(user)
            expect(Recipe.last.name).to eq('Kung fu pasta')
            expect(Recipe.last.process).to eq('Cook spaghetti accoring to package instructions.\n\nAdd some funky Chinese sauce and feel the burn.')
            expect(Recipe.last.photo.url).to include('test-photo.jpg')
            expect(Recipe.last.state).to eq('incomplete')
          end

          it 'creates one ingredient' do
            expect { post :create, params: params, format: :json }.to change(Ingredient, :count).by(1)
          end

          it 'gives the ingredient the correct details' do
            post :create, params: params, format: :json
            expect(Ingredient.last.id).to be_present
            expect(Ingredient.last.recipe).to eq(Recipe.last)
            expect(Ingredient.last.amount).to eq('1')
            expect(Ingredient.last.unit).to eq('jar')
            expect(Ingredient.last.food).to eq('Jam')
            expect(Ingredient.last.preparation).to eq('mashed')
            expect(Ingredient.last.optional).to eq(false)
          end

          it 'returns the new recipe' do
            post :create, params: params, format: :json
            expect(JSON.parse(response.body)['id']).to eq(Recipe.last.id)
            expect(JSON.parse(response.body)['name']).to eq('Kung fu pasta')
            expect(JSON.parse(response.body)['process']).to eq('Cook spaghetti accoring to package instructions.\n\nAdd some funky Chinese sauce and feel the burn.')
            expect(JSON.parse(response.body)['photo']['url']).to include('test-photo.jpg')
            expect(JSON.parse(response.body)['ingredients'][0]['id']).to eq(Ingredient.last.id)
            expect(JSON.parse(response.body)['ingredients'][0]['recipe_id']).to eq(Recipe.last.id)
            expect(JSON.parse(response.body)['ingredients'][0]['amount']).to eq('1')
            expect(JSON.parse(response.body)['ingredients'][0]['unit']).to eq('jar')
            expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Jam')
            expect(JSON.parse(response.body)['ingredients'][0]['preparation']).to eq('mashed')
            expect(JSON.parse(response.body)['ingredients'][0]['optional']).to eq(false)
            expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
            expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
            expect(JSON.parse(response.body)['author']['twitter_handle']).to eq('cushiondiaries')
            expect(JSON.parse(response.body)['author']['instagram_username']).to eq('coffeetableselfies')
            expect(JSON.parse(response.body)['author']['website']).to eq('www.dontsitonme.com')
          end
        end

        context 'three ingredients' do
          it 'creates a recipe' do
            expect { post :create, params: params, format: :json }.to change(Recipe, :count).by(1)
          end

          it 'gives the recipe the correct details' do
            post :create, params: params, format: :json
            expect(Recipe.last.id).to be_present
            expect(Recipe.last.user).to eq(user)
            expect(Recipe.last.name).to eq('Jam salad')
            expect(Recipe.last.process).to eq('Mix jam with lettuce leaves and tomatoes')
            expect(Recipe.last.photo.url).to include('test-photo.jpg')
            expect(Recipe.last.state).to eq('incomplete')
          end

          it 'creates three ingredients' do
            expect { post :create, params: params, format: :json }.to change(Ingredient, :count).by(3)
          end

          it 'gives the ingredients the correct details' do
            post :create, params: params, format: :json
            expect(Ingredient.last.id).to be_present
            expect(Ingredient.second_to_last.id).to be_present
            expect(Ingredient.third_to_last.id).to be_present
            expect(Ingredient.last.recipe).to eq(Recipe.last)
            expect(Ingredient.second_to_last.recipe).to eq(Recipe.last)
            expect(Ingredient.third_to_last.recipe).to eq(Recipe.last)
            expect(Ingredient.last(3).map(&:amount)).to include('1', '2', nil)
            expect(Ingredient.last(3).map(&:unit)).to include('jar', nil)
            expect(Ingredient.last(3).map(&:food)).to include('Jam', 'Iceberg lettuce', 'Tomatoes')
            expect(Ingredient.last(3).map(&:preparation)).to include('mashed', 'Chopped', nil)
            expect(Ingredient.last(3).map(&:optional)).to include(false, true)
          end

          it 'returns the new recipe' do
            post :create, params: params, format: :json
            expect(JSON.parse(response.body)['id']).to eq(Recipe.last.id)
            expect(JSON.parse(response.body)['name']).to eq('Jam salad')
            expect(JSON.parse(response.body)['process']).to eq('Mix jam with lettuce leaves and tomatoes')
            expect(JSON.parse(response.body)['photo']['url']).to include('test-photo.jpg')
            expect(JSON.parse(response.body)['ingredients'][0]['id']).to eq(Ingredient.last.id).or(eq(Ingredient.second_to_last.id)).or(eq(Ingredient.third_to_last.id))
            expect(JSON.parse(response.body)['ingredients'][0]['recipe_id']).to eq(Recipe.last.id)
            expect(JSON.parse(response.body)['ingredients'][0]['amount']).to eq('1').or(eq('2')).or(eq(nil))
            expect(JSON.parse(response.body)['ingredients'][0]['unit']).to eq('jar').or(eq(nil))
            expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Jam').or(eq('Iceberg lettuce')).or(eq('Tomatoes'))
            expect(JSON.parse(response.body)['ingredients'][0]['preparation']).to eq('mashed').or(eq('Chopped')).or(eq(nil))
            expect(JSON.parse(response.body)['ingredients'][0]['optional']).to eq(false).or(eq(true))

            expect(JSON.parse(response.body)['ingredients'][1]['id']).to eq(Ingredient.last.id).or(eq(Ingredient.second_to_last.id)).or(eq(Ingredient.third_to_last.id))
            expect(JSON.parse(response.body)['ingredients'][1]['recipe_id']).to eq(Recipe.last.id)
            expect(JSON.parse(response.body)['ingredients'][1]['amount']).to eq('1').or(eq('2')).or(eq(nil))
            expect(JSON.parse(response.body)['ingredients'][1]['unit']).to eq('jar').or(eq(nil))
            expect(JSON.parse(response.body)['ingredients'][1]['food']).to eq('Jam').or(eq('Iceberg lettuce')).or(eq('Tomatoes'))
            expect(JSON.parse(response.body)['ingredients'][1]['preparation']).to eq('mashed').or(eq('Chopped')).or(eq(nil))
            expect(JSON.parse(response.body)['ingredients'][1]['optional']).to eq(false).or(eq(true))

            expect(JSON.parse(response.body)['ingredients'][2]['id']).to eq(Ingredient.last.id).or(eq(Ingredient.second_to_last.id)).or(eq(Ingredient.third_to_last.id))
            expect(JSON.parse(response.body)['ingredients'][2]['recipe_id']).to eq(Recipe.last.id)
            expect(JSON.parse(response.body)['ingredients'][2]['amount']).to eq('1').or(eq('2')).or(eq(nil))
            expect(JSON.parse(response.body)['ingredients'][2]['unit']).to eq('jar').or(eq(nil))
            expect(JSON.parse(response.body)['ingredients'][2]['food']).to eq('Jam').or(eq('Iceberg lettuce')).or(eq('Tomatoes'))
            expect(JSON.parse(response.body)['ingredients'][2]['preparation']).to eq('mashed').or(eq('Chopped')).or(eq(nil))
            expect(JSON.parse(response.body)['ingredients'][2]['optional']).to eq(false).or(eq(true))

            expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
            expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
            expect(JSON.parse(response.body)['author']['twitter_handle']).to eq('cushiondiaries')
            expect(JSON.parse(response.body)['author']['instagram_username']).to eq('coffeetableselfies')
            expect(JSON.parse(response.body)['author']['website']).to eq('www.dontsitonme.com')
          end
        end
      end

      context 'save is not successful' do
        before { allow_any_instance_of(Recipe).to receive(:save).and_return(false) }
        it 'returns an errors hash' do
          post :create, params: params, format: :json
          expect(JSON.parse(response.body)).to eq({'errors' => []})
        end
      end
    end

    context 'user does not exist' do
      let(:headers) { { 'X-User-Email' => 'fakeemail@scoopy.doo', 'X-User-Token' => '123456' } }
      let(:params) { { recipe: { name: 'Volcanic intensity', process: 'Add volcano to life', photo: test_photo } } }
      it 'does not create a recipe' do
        expect { post :create, params: params, format: :json }.to change(Recipe, :count).by(0)
      end

      it 'returns error' do
        post :create, params: params, format: :json
        expect(JSON.parse(response.body)).to eq('error' => '')
      end
    end
  end

  describe 'GET #index' do
    render_views
    context 'there is one recipe' do
      it 'returns 1 recipe' do
        get :index, { format: :json }
        expect(JSON.parse(response.body).count).to eq(1)
      end

      it 'returns the recipe details' do
        get :index, { format: :json }
        expect(JSON.parse(response.body)[0]['id']).to eq(recipe.id)
        expect(JSON.parse(response.body)[0]['name']).to eq('Food with food on top')
        expect(JSON.parse(response.body)[0]['author']['id']).to eq(user.id)
        expect(JSON.parse(response.body)[0]['author']['username']).to eq('steve_the_sofa')
      end
    end

    context 'there are multiple recipes' do
      let(:user_2) { create(:user, username: 'larry_the_lamp') }
      let!(:recipe_2) { create(:recipe, user: user_2, name: 'Banana') }
      let!(:invalid_recipe) { create(:recipe, state: :incomplete) }
      it 'returns 2 recipes' do
        get :index, { format: :json }
        expect(JSON.parse(response.body).count).to eq(2)
      end

      it 'returns the details of both recipes' do
        get :index, { format: :json }
        expect(JSON.parse(response.body)[0]['id']).to eq(recipe.id).or(eq(recipe_2.id))
        expect(JSON.parse(response.body)[0]['name']).to eq('Food with food on top').or(eq('Banana'))
        expect(JSON.parse(response.body)[0]['author']['id']).to eq(user.id).or(eq(user_2.id))
        expect(JSON.parse(response.body)[0]['author']['username']).to eq('steve_the_sofa').or(eq('larry_the_lamp'))

        expect(JSON.parse(response.body)[1]['id']).to eq(recipe.id).or(eq(recipe_2.id))
        expect(JSON.parse(response.body)[1]['name']).to eq('Food with food on top').or(eq('Banana'))
        expect(JSON.parse(response.body)[1]['author']['id']).to eq(user.id).or(eq(user_2.id))
        expect(JSON.parse(response.body)[1]['author']['username']).to eq('steve_the_sofa').or(eq('larry_the_lamp'))
      end
    end

    context 'there are no recipes' do
      let!(:recipe) { nil }
      let!(:ingredient_1) { nil }
      let!(:ingredient_2) { nil }
      let!(:ingredient_3) { nil }
      it 'returns 0 recipes' do
        get :index, { format: :json }
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'returns an empty array' do
        get :index, { format: :json }
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe 'GET #show' do
    render_views
    context 'recipe exists' do
      context 'it has no ingredients' do
        let(:user) { create(:user, username: 'matt_the_mat', twitter_handle: '', instagram_handle: '', website_url: '') }
        let!(:ingredient_1) { nil }
        let!(:ingredient_2) { nil }
        let!(:ingredient_3) { nil }
        it 'returns the recipe details' do
          get :show, params: { id: recipe.id, format: :json }
          expect(JSON.parse(response.body)['id']).to eq(recipe.id)
          expect(JSON.parse(response.body)['name']).to eq('Food with food on top')
          expect(JSON.parse(response.body)['process']).to eq('Put all the food into a bowl of food, mix well, then top with food')

          expect(JSON.parse(response.body)['ingredients'].count).to eq(0)

          expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
          expect(JSON.parse(response.body)['author']['username']).to eq('matt_the_mat')
          expect(JSON.parse(response.body)['author']['twitter_handle']).to eq(nil)
          expect(JSON.parse(response.body)['author']['instagram_username']).to eq(nil)
          expect(JSON.parse(response.body)['author']['website']).to eq(nil)
        end
      end

      context 'it has one ingredient' do
        let(:user) { create(:user, username: 'cup_the_cup', twitter_handle: nil, instagram_handle: nil, website_url: nil) }
        let!(:ingredient_2) { nil }
        let!(:ingredient_3) { nil }
        it 'returns the recipe details' do
          get :show, params: { id: recipe.id, format: :json }
          expect(JSON.parse(response.body)['id']).to eq(recipe.id)
          expect(JSON.parse(response.body)['name']).to eq('Food with food on top')
          expect(JSON.parse(response.body)['process']).to eq('Put all the food into a bowl of food, mix well, then top with food')

          expect(JSON.parse(response.body)['ingredients'].count).to eq(1)

          expect(JSON.parse(response.body)['ingredients'][0]['id']).to eq(ingredient_1.id)
          expect(JSON.parse(response.body)['ingredients'][0]['recipe_id']).to eq(recipe.id)
          expect(JSON.parse(response.body)['ingredients'][0]['amount']).to eq('Some')
          expect(JSON.parse(response.body)['ingredients'][0]['unit']).to eq(nil)
          expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Green leaves')
          expect(JSON.parse(response.body)['ingredients'][0]['preparation']).to eq('Shredded')
          expect(JSON.parse(response.body)['ingredients'][0]['optional']).to eq(false)

          expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
          expect(JSON.parse(response.body)['author']['username']).to eq('cup_the_cup')
          expect(JSON.parse(response.body)['author']['twitter_handle']).to eq(nil)
          expect(JSON.parse(response.body)['author']['instagram_username']).to eq(nil)
          expect(JSON.parse(response.body)['author']['website']).to eq(nil)
        end
      end

      context 'it has many ingredients' do
        it 'returns the recipe details' do
          get :show, params: { id: recipe.id, format: :json }
          expect(JSON.parse(response.body)['id']).to eq(recipe.id)
          expect(JSON.parse(response.body)['name']).to eq('Food with food on top')
          expect(JSON.parse(response.body)['process']).to eq('Put all the food into a bowl of food, mix well, then top with food')

          expect(JSON.parse(response.body)['ingredients'].count).to eq(3)

          expect(JSON.parse(response.body)['ingredients'][0]['id']).to eq(ingredient_1.id).or(eq(ingredient_2.id)).or(eq(ingredient_3.id))
          expect(JSON.parse(response.body)['ingredients'][0]['recipe_id']).to eq(recipe.id)
          expect(JSON.parse(response.body)['ingredients'][0]['amount']).to eq('Some').or(eq('100')).or(eq(nil))
          expect(JSON.parse(response.body)['ingredients'][0]['unit']).to eq(nil).or(eq('grams'))
          expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot'))
          expect(JSON.parse(response.body)['ingredients'][0]['preparation']).to eq('Shredded').or(eq(nil))
          expect(JSON.parse(response.body)['ingredients'][0]['optional']).to eq(false).or(eq(true))

          expect(JSON.parse(response.body)['ingredients'][1]['id']).to eq(ingredient_1.id).or(eq(ingredient_2.id)).or(eq(ingredient_3.id))
          expect(JSON.parse(response.body)['ingredients'][1]['recipe_id']).to eq(recipe.id)
          expect(JSON.parse(response.body)['ingredients'][1]['amount']).to eq('Some').or(eq('100')).or(eq(nil))
          expect(JSON.parse(response.body)['ingredients'][1]['unit']).to eq(nil).or(eq('grams'))
          expect(JSON.parse(response.body)['ingredients'][1]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot'))
          expect(JSON.parse(response.body)['ingredients'][1]['preparation']).to eq('Shredded').or(eq(nil))
          expect(JSON.parse(response.body)['ingredients'][1]['optional']).to eq(false).or(eq(true))

          expect(JSON.parse(response.body)['ingredients'][2]['id']).to eq(ingredient_1.id).or(eq(ingredient_2.id)).or(eq(ingredient_3.id))
          expect(JSON.parse(response.body)['ingredients'][2]['recipe_id']).to eq(recipe.id)
          expect(JSON.parse(response.body)['ingredients'][2]['amount']).to eq('Some').or(eq('100')).or(eq(nil))
          expect(JSON.parse(response.body)['ingredients'][2]['unit']).to eq(nil).or(eq('grams'))
          expect(JSON.parse(response.body)['ingredients'][2]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot'))
          expect(JSON.parse(response.body)['ingredients'][2]['preparation']).to eq('Shredded').or(eq(nil))
          expect(JSON.parse(response.body)['ingredients'][2]['optional']).to eq(false).or(eq(true))

          expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
          expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
          expect(JSON.parse(response.body)['author']['twitter_handle']).to eq('cushiondiaries')
          expect(JSON.parse(response.body)['author']['instagram_username']).to eq('coffeetableselfies')
          expect(JSON.parse(response.body)['author']['website']).to eq('www.dontsitonme.com')
        end
      end
    end

    context 'recipe does not exist' do
      it 'returns an error' do
        get :show, params: { id: 9999, format: :json }
        expect(JSON.parse(response.body)).to eq({'error' => "Couldn't find Recipe with 'id'=9999"})
      end
    end
  end

  describe 'PATCH #update' do
    # COMPLETE THIS
  end

  describe 'DELETE #destroy' do
    # COMPLETE THIS
  end
end
