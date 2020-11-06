require 'rails_helper'

describe Api::V1::RecipesController, type: :controller do
  let(:user) { create(:user, username: 'steve_the_sofa', twitter_handle: 'cushiondiaries', instagram_handle: 'coffeetableselfies', website_url: 'www.dontsitonme.com') }
  let(:recipe) { create(:recipe, user: user, name: 'Food with food on top', process: 'Put all the food into a bowl of food, mix well, then top with food', photo: test_photo) }
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

            it 'returns 200' do
              post :create, params: params, format: :json
              expect(response).to have_http_status(:ok)
            end

            context 'mark_as_complete is passed-in' do
              context 'mark_as_complete is true' do
                let(:params) { { recipe: { name: 'Mushroom car banana', process: 'Scrape mould from yellow boat', photo: test_photo, mark_as_complete: true } } }
                it 'updates the state to awaiting_approval' do
                  post :create, params: params, format: :json
                  expect(Recipe.last.name).to eq('Mushroom car banana')
                  expect(Recipe.last.process).to eq('Scrape mould from yellow boat')
                  expect(Recipe.last.photo.url).to include('test-photo.jpg')
                  expect(Recipe.last.state).to eq('awaiting_approval')
                end

                it 'returns the new recipe' do
                  post :create, params: params, format: :json
                  expect(JSON.parse(response.body)['name']).to eq('Mushroom car banana')
                  expect(JSON.parse(response.body)['process']).to eq('Scrape mould from yellow boat')
                  expect(JSON.parse(response.body)['photo']['url']).to include('test-photo.jpg')
                  expect(JSON.parse(response.body)['ingredients']).to eq([])
                  expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
                  expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
                end

                it 'returns 200' do
                  post :create, params: params, format: :json
                  expect(response).to have_http_status(:ok)
                end
              end

              context 'mark_as_complete is truthy' do
                let(:params) { { recipe: { name: 'Day jaw food', process: 'Chew lightly prior to sunset', photo: test_photo, mark_as_complete: 1 } } }
                it 'updates the state to awaiting_approval' do
                  post :create, params: params, format: :json
                  expect(Recipe.last.name).to eq('Day jaw food')
                  expect(Recipe.last.process).to eq('Chew lightly prior to sunset')
                  expect(Recipe.last.photo.url).to include('test-photo.jpg')
                  expect(Recipe.last.state).to eq('awaiting_approval')
                end
              end

              context 'mark_as_complete is false' do
                let(:params) { { recipe: { name: 'Chicken teacup my salad', process: 'Scare mug with cucumber', photo: test_photo, mark_as_complete: false } } }
                it 'does not update the state from incomplete' do
                  post :create, params: params, format: :json
                  expect(Recipe.last.name).to eq('Chicken teacup my salad')
                  expect(Recipe.last.process).to eq('Scare mug with cucumber')
                  expect(Recipe.last.photo.url).to include('test-photo.jpg')
                  expect(Recipe.last.state).to eq('incomplete')
                end
              end

              context 'mark_as_complete is nil' do
                let(:params) { { recipe: { name: 'Carry bean', process: 'Place pinto in bag', photo: test_photo, mark_as_complete: nil } } }
                it 'does not update the state from incomplete' do
                  post :create, params: params, format: :json
                  expect(Recipe.last.name).to eq('Carry bean')
                  expect(Recipe.last.process).to eq('Place pinto in bag')
                  expect(Recipe.last.photo.url).to include('test-photo.jpg')
                  expect(Recipe.last.state).to eq('incomplete')
                end
              end

              context 'mark_as_complete is an empty string' do
                let(:params) { { recipe: { name: 'Pure bread rottweiler', process: 'Place puppy in bread machine', photo: test_photo, mark_as_complete: '' } } }
                it 'does not update the state from incomplete' do
                  post :create, params: params, format: :json
                  expect(Recipe.last.name).to eq('Pure bread rottweiler')
                  expect(Recipe.last.process).to eq('Place puppy in bread machine')
                  expect(Recipe.last.photo.url).to include('test-photo.jpg')
                  expect(Recipe.last.state).to eq('incomplete')
                end
              end
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

            it 'returns 200' do
              post :create, params: params, format: :json
              expect(response).to have_http_status(:ok)
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

          it 'returns 200' do
            post :create, params: params, format: :json
            expect(response).to have_http_status(:ok)
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

          it 'returns 200' do
            post :create, params: params, format: :json
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'save is not successful' do
        before { allow_any_instance_of(Recipe).to receive(:save).and_return(false) }
        it 'returns an errors hash' do
          post :create, params: params, format: :json
          expect(JSON.parse(response.body)).to eq({'errors' => []})
        end

        it 'returns 422' do
          post :create, params: params, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
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

      it 'returns 401' do
        post :create, params: params, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #index' do
    render_views
    context 'there is one recipe' do
      it 'returns 1 recipe' do
        get :index, format: :json
        expect(JSON.parse(response.body).count).to eq(1)
      end

      it 'returns the recipe details' do
        get :index, format: :json
        expect(JSON.parse(response.body)[0]['id']).to eq(recipe.id)
        expect(JSON.parse(response.body)[0]['name']).to eq('Food with food on top')
        expect(JSON.parse(response.body)[0]['author']['id']).to eq(user.id)
        expect(JSON.parse(response.body)[0]['author']['username']).to eq('steve_the_sofa')
      end

      it 'returns 200' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'there are multiple recipes' do
      let(:user_2) { create(:user, username: 'larry_the_lamp') }
      let!(:recipe_2) { create(:recipe, user: user_2, name: 'Banana') }
      let!(:invalid_recipe) { create(:recipe, state: :incomplete) }
      it 'returns 2 recipes' do
        get :index, format: :json
        expect(JSON.parse(response.body).count).to eq(2)
      end

      it 'returns the details of both recipes' do
        get :index, format: :json
        expect(JSON.parse(response.body)[0]['id']).to eq(recipe.id).or(eq(recipe_2.id))
        expect(JSON.parse(response.body)[0]['name']).to eq('Food with food on top').or(eq('Banana'))
        expect(JSON.parse(response.body)[0]['author']['id']).to eq(user.id).or(eq(user_2.id))
        expect(JSON.parse(response.body)[0]['author']['username']).to eq('steve_the_sofa').or(eq('larry_the_lamp'))

        expect(JSON.parse(response.body)[1]['id']).to eq(recipe.id).or(eq(recipe_2.id))
        expect(JSON.parse(response.body)[1]['name']).to eq('Food with food on top').or(eq('Banana'))
        expect(JSON.parse(response.body)[1]['author']['id']).to eq(user.id).or(eq(user_2.id))
        expect(JSON.parse(response.body)[1]['author']['username']).to eq('steve_the_sofa').or(eq('larry_the_lamp'))
      end

      it 'returns 200' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'there are no recipes' do
      let!(:recipe) { nil }
      let!(:ingredient_1) { nil }
      let!(:ingredient_2) { nil }
      let!(:ingredient_3) { nil }
      it 'returns 0 recipes' do
        get :index, format: :json
        expect(JSON.parse(response.body).count).to eq(0)
      end

      it 'returns an empty array' do
        get :index, format: :json
        expect(JSON.parse(response.body)).to eq([])
      end

      it 'returns 200' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
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

        it 'returns 200' do
          get :show, params: { id: recipe.id, format: :json }
          expect(response).to have_http_status(:ok)
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

        it 'returns 200' do
          get :show, params: { id: recipe.id, format: :json }
          expect(response).to have_http_status(:ok)
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

        it 'returns 200' do
          get :show, params: { id: recipe.id, format: :json }
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'recipe does not exist' do
      it 'returns an error' do
        get :show, params: { id: 9999, format: :json }
        expect(JSON.parse(response.body)).to eq({'error' => "Couldn't find Recipe with 'id'=9999"})
      end

      it 'returns 404' do
        get :show, params: { id: 9999, format: :json }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PATCH #update' do
    let(:test_photo_2) { fixture_file_upload(Rails.root.join('public', 'test-photo-2.jpg'), 'image/jpg') }
    let(:headers) { { 'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token } }
    render_views
    before { request.headers.merge!(headers) }
    context 'recipe exists' do
      context 'user is recipe owner' do
        context 'update is successful' do
          context 'ingredients are not amended' do
            let(:params) { { id: recipe.id, recipe: { name: 'Bone Apple Tea', process: 'Boil water and pour over apple bone', photo: test_photo_2 } } }
            it 'updates the recipe' do
              expect(recipe.name).to eq('Food with food on top')
              expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
              expect(recipe.photo.url).to include('test-photo.jpg')
              expect(recipe.state).to eq('approved')
              patch :update, params: params, format: :json
              expect(recipe.reload.name).to eq('Bone Apple Tea')
              expect(recipe.process).to eq('Boil water and pour over apple bone')
              expect(recipe.photo.url).to include('test-photo-2.jpg')
              expect(recipe.state).to eq('incomplete')
            end

            it 'returns the amended recipe' do
              patch :update, params: params, format: :json
              expect(JSON.parse(response.body)['name']).to eq('Bone Apple Tea')
              expect(JSON.parse(response.body)['process']).to eq('Boil water and pour over apple bone')
              expect(JSON.parse(response.body)['photo']['url']).to include('test-photo-2.jpg')

              expect(JSON.parse(response.body)['ingredients'].count).to eq(3)

              expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
              expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
            end

            it 'returns 200' do
              patch :update, params: params, format: :json
              expect(response).to have_http_status(:ok)
            end

            context 'mark_as_complete is passed-in' do
              context 'mark_as_complete is true' do
                let(:params) { { id: recipe.id, recipe: { name: 'Roman coke', process: 'Pour Coca-cola into glass with Cesar', photo: test_photo_2, mark_as_complete: true } } }
                it 'updates the state to awaiting_approval' do
                  expect(recipe.name).to eq('Food with food on top')
                  expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
                  expect(recipe.photo.url).to include('test-photo.jpg')
                  expect(recipe.state).to eq('approved')
                  patch :update, params: params, format: :json
                  expect(recipe.reload.name).to eq('Roman coke')
                  expect(recipe.process).to eq('Pour Coca-cola into glass with Cesar')
                  expect(recipe.photo.url).to include('test-photo-2.jpg')
                  expect(recipe.state).to eq('awaiting_approval')
                end

                it 'returns the amended recipe' do
                  patch :update, params: params, format: :json
                  expect(JSON.parse(response.body)['name']).to eq('Roman coke')
                  expect(JSON.parse(response.body)['process']).to eq('Pour Coca-cola into glass with Cesar')
                  expect(JSON.parse(response.body)['photo']['url']).to include('test-photo-2.jpg')

                  expect(JSON.parse(response.body)['ingredients'].count).to eq(3)

                  expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
                  expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
                end

                it 'returns 200' do
                  patch :update, params: params, format: :json
                  expect(response).to have_http_status(:ok)
                end
              end

              context 'mark_as_complete is truthy' do
                let(:params) { { id: recipe.id, recipe: { name: 'Seizure salad', process: 'Mix lettuce with strobe lighting', photo: test_photo_2, mark_as_complete: 1 } } }
                it 'updates the state to awaiting_approval' do
                  expect(recipe.name).to eq('Food with food on top')
                  expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
                  expect(recipe.photo.url).to include('test-photo.jpg')
                  expect(recipe.state).to eq('approved')
                  patch :update, params: params, format: :json
                  expect(recipe.reload.name).to eq('Seizure salad')
                  expect(recipe.process).to eq('Mix lettuce with strobe lighting')
                  expect(recipe.photo.url).to include('test-photo-2.jpg')
                  expect(recipe.state).to eq('awaiting_approval')
                end
              end

              context 'mark_as_complete is false' do
                let(:params) { { id: recipe.id, recipe: { name: 'Rigid Tony', process: 'Just touch Tony', photo: test_photo_2, mark_as_complete: false } } }
                it 'updates the state to incomplete' do
                  expect(recipe.name).to eq('Food with food on top')
                  expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
                  expect(recipe.photo.url).to include('test-photo.jpg')
                  expect(recipe.state).to eq('approved')
                  patch :update, params: params, format: :json
                  expect(recipe.reload.name).to eq('Rigid Tony')
                  expect(recipe.process).to eq('Just touch Tony')
                  expect(recipe.photo.url).to include('test-photo-2.jpg')
                  expect(recipe.state).to eq('incomplete')
                end

                it 'returns 200' do
                  patch :update, params: params, format: :json
                  expect(response).to have_http_status(:ok)
                end
              end

              context 'mark_as_complete is nil' do
                let(:params) { { id: recipe.id, recipe: { name: 'Chicken condom blue', process: 'Wrap chicken in navy rubber', photo: test_photo_2, mark_as_complete: nil } } }
                it 'updates the state to incomplete' do
                  expect(recipe.name).to eq('Food with food on top')
                  expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
                  expect(recipe.photo.url).to include('test-photo.jpg')
                  expect(recipe.state).to eq('approved')
                  patch :update, params: params, format: :json
                  expect(recipe.reload.name).to eq('Chicken condom blue')
                  expect(recipe.process).to eq('Wrap chicken in navy rubber')
                  expect(recipe.photo.url).to include('test-photo-2.jpg')
                  expect(recipe.state).to eq('incomplete')
                end

                it 'returns 200' do
                  patch :update, params: params, format: :json
                  expect(response).to have_http_status(:ok)
                end
              end

              context 'mark_as_complete is an empty string' do
                let(:params) { { id: recipe.id, recipe: { name: 'Eggs eye and tea', process: 'Pour boiling water over yolk', photo: test_photo_2, mark_as_complete: '' } } }
                it 'updates the state to incomplete' do
                  expect(recipe.name).to eq('Food with food on top')
                  expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
                  expect(recipe.photo.url).to include('test-photo.jpg')
                  expect(recipe.state).to eq('approved')
                  patch :update, params: params, format: :json
                  expect(recipe.reload.name).to eq('Eggs eye and tea')
                  expect(recipe.process).to eq('Pour boiling water over yolk')
                  expect(recipe.photo.url).to include('test-photo-2.jpg')
                  expect(recipe.state).to eq('incomplete')
                end

                it 'returns 200' do
                  patch :update, params: params, format: :json
                  expect(response).to have_http_status(:ok)
                end
              end
            end
          end

          context 'new ingredients are added' do
            context 'one ingredient is added' do
              let(:params) { { id: recipe.id, recipe: { name: 'Cart Door', process: 'Remove door from cart', photo: test_photo_2, ingredients_attributes: [ ingredient_4_params ] } } }
              let(:ingredient_4_params) { { amount: '10', unit: 'handful', food: 'Wood panels', preparation: 'Sanded', optional: false } }
              it 'updates the recipe' do
                expect(recipe.name).to eq('Food with food on top')
                expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
                expect(recipe.photo.url).to include('test-photo.jpg')
                expect(recipe.state).to eq('approved')
                patch :update, params: params, format: :json
                expect(recipe.reload.name).to eq('Cart Door')
                expect(recipe.process).to eq('Remove door from cart')
                expect(recipe.photo.url).to include('test-photo-2.jpg')
                expect(recipe.state).to eq('incomplete')
              end

              it 'creates one ingredient' do
                expect { patch :update, params: params, format: :json }.to change(Ingredient, :count).by(1)
                expect(Ingredient.count).to eq(4)
              end

              it 'gives the new ingredient the correct details' do
                patch :update, params: params, format: :json
                expect(Ingredient.last.id).to be_present
                expect(Ingredient.last.recipe).to eq(recipe)
                expect(Ingredient.last.amount).to eq('10')
                expect(Ingredient.last.unit).to eq('handful')
                expect(Ingredient.last.food).to eq('Wood panels')
                expect(Ingredient.last.preparation).to eq('Sanded')
                expect(Ingredient.last.optional).to eq(false)
              end

              it 'returns the recipe and all four ingredients' do
                patch :update, params: params, format: :json
                expect(JSON.parse(response.body)['name']).to eq('Cart Door')
                expect(JSON.parse(response.body)['process']).to eq('Remove door from cart')
                expect(JSON.parse(response.body)['photo']['url']).to include('test-photo-2.jpg')

                expect(JSON.parse(response.body)['ingredients'].count).to eq(4)

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

                expect(JSON.parse(response.body)['ingredients'][3]['id']).to eq(Ingredient.last.id)
                expect(JSON.parse(response.body)['ingredients'][3]['recipe_id']).to eq(recipe.id)
                expect(JSON.parse(response.body)['ingredients'][3]['amount']).to eq('10')
                expect(JSON.parse(response.body)['ingredients'][3]['unit']).to eq('handful')
                expect(JSON.parse(response.body)['ingredients'][3]['food']).to eq('Wood panels')
                expect(JSON.parse(response.body)['ingredients'][3]['preparation']).to eq('Sanded')
                expect(JSON.parse(response.body)['ingredients'][3]['optional']).to eq(false)

                expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
                expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
              end

              it 'returns 200' do
                patch :update, params: params, format: :json
                expect(response).to have_http_status(:ok)
              end
            end

            context 'multiple ingrdients are added' do
              let(:params) { { id: recipe.id, recipe: { name: 'Carte Wheel', process: 'Mix cart with wheel', photo: test_photo_2, ingredients_attributes: [ ingredient_4_params, ingredient_5_params ] } } }
              let(:ingredient_4_params) { { amount: '5', unit: 'clove', food: 'Cart', preparation: 'assembled', optional: false } }
              let(:ingredient_5_params) { { amount: '4', unit: nil, food: 'Wheel', preparation: 'Rounded', optional: true } }
              it 'updates the recipe' do
                expect(recipe.name).to eq('Food with food on top')
                expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
                expect(recipe.photo.url).to include('test-photo.jpg')
                expect(recipe.state).to eq('approved')
                patch :update, params: params, format: :json
                expect(recipe.reload.name).to eq('Carte Wheel')
                expect(recipe.process).to eq('Mix cart with wheel')
                expect(recipe.photo.url).to include('test-photo-2.jpg')
                expect(recipe.state).to eq('incomplete')
              end

              it 'creates two ingredients' do
                expect { patch :update, params: params, format: :json }.to change(Ingredient, :count).by(2)
                expect(Ingredient.count).to eq(5)
              end

              it 'gives the new ingredients the correct details' do
                patch :update, params: params, format: :json
                expect(Ingredient.last.id).to be_present
                expect(Ingredient.second_to_last.id).to be_present
                expect(Ingredient.last.recipe).to eq(recipe)
                expect(Ingredient.second_to_last.recipe).to eq(recipe)
                expect(Ingredient.last(2).map(&:amount)).to include('5', '4')
                expect(Ingredient.last(2).map(&:unit)).to include('clove', nil)
                expect(Ingredient.last(2).map(&:food)).to include('Cart', 'Wheel')
                expect(Ingredient.last(2).map(&:preparation)).to include('assembled', 'Rounded')
                expect(Ingredient.last(2).map(&:optional)).to include(false, true)
              end

              it 'returns the recipe and all five ingredients' do
                patch :update, params: params, format: :json
                expect(JSON.parse(response.body)['name']).to eq('Carte Wheel')
                expect(JSON.parse(response.body)['process']).to eq('Mix cart with wheel')
                expect(JSON.parse(response.body)['photo']['url']).to include('test-photo-2.jpg')

                expect(JSON.parse(response.body)['ingredients'].count).to eq(5)

                expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot')).or (eq('Cart')).or (eq('Wheel'))
                expect(JSON.parse(response.body)['ingredients'][1]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot')).or (eq('Cart')).or (eq('Wheel'))
                expect(JSON.parse(response.body)['ingredients'][2]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot')).or (eq('Cart')).or (eq('Wheel'))
                expect(JSON.parse(response.body)['ingredients'][3]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot')).or (eq('Cart')).or (eq('Wheel'))
                expect(JSON.parse(response.body)['ingredients'][4]['food']).to eq('Green leaves').or(eq('Bountiful fruit')).or(eq('Fanciful loot')).or (eq('Cart')).or (eq('Wheel'))

                expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
                expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
              end

              it 'returns 200' do
                patch :update, params: params, format: :json
                expect(response).to have_http_status(:ok)
              end
            end
          end

          context 'existing ingredients are updated' do
            context 'one ingredient is updated' do
              let(:params) { { id: recipe.id, recipe: { name: 'Blah blah black sheep', process: 'Ask sheep the meaning of life', photo: test_photo_2, ingredients_attributes: [ ingredient_1_params ] } } }
              let(:ingredient_1_params) { { id: ingredient_1.id, amount: '1', unit: 'dollop', food: 'Sheep wisdom', preparation: 'translated', optional: true } }
              it 'updates the recipe' do
                expect(recipe.name).to eq('Food with food on top')
                expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
                expect(recipe.photo.url).to include('test-photo.jpg')
                expect(recipe.state).to eq('approved')
                patch :update, params: params, format: :json
                expect(recipe.reload.name).to eq('Blah blah black sheep')
                expect(recipe.process).to eq('Ask sheep the meaning of life')
                expect(recipe.photo.url).to include('test-photo-2.jpg')
                expect(recipe.state).to eq('incomplete')
              end

              it 'does not create any ingredients' do
                expect { patch :update, params: params, format: :json }.to change(Ingredient, :count).by(0)
                expect(Ingredient.count).to eq(3)
              end

              it 'updates the relevant ingredient' do
                expect(ingredient_1.amount).to eq('Some')
                expect(ingredient_1.unit).to eq(nil)
                expect(ingredient_1.food).to eq('Green leaves')
                expect(ingredient_1.preparation).to eq('Shredded')
                expect(ingredient_1.optional).to eq(false)
                patch :update, params: params, format: :json
                expect(ingredient_1.reload.amount).to eq('1')
                expect(ingredient_1.unit).to eq('dollop')
                expect(ingredient_1.food).to eq('Sheep wisdom')
                expect(ingredient_1.preparation).to eq('translated')
                expect(ingredient_1.optional).to eq(true)
              end

              it 'returns the recipe and the three ingredients' do
                patch :update, params: params, format: :json
                expect(JSON.parse(response.body)['name']).to eq('Blah blah black sheep')
                expect(JSON.parse(response.body)['process']).to eq('Ask sheep the meaning of life')
                expect(JSON.parse(response.body)['photo']['url']).to include('test-photo-2.jpg')

                expect(JSON.parse(response.body)['ingredients'].count).to eq(3)

                expect(JSON.parse(response.body)['ingredients'][0]['id']).to eq(ingredient_1.id).or(eq(ingredient_2.id)).or(eq(ingredient_3.id))
                expect(JSON.parse(response.body)['ingredients'][0]['recipe_id']).to eq(recipe.id)
                expect(JSON.parse(response.body)['ingredients'][0]['amount']).to eq('1').or(eq('100')).or(eq(nil))
                expect(JSON.parse(response.body)['ingredients'][0]['unit']).to eq('dollop').or(eq('grams')).or(eq(nil))
                expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Sheep wisdom').or(eq('Bountiful fruit')).or(eq('Fanciful loot'))
                expect(JSON.parse(response.body)['ingredients'][0]['preparation']).to eq('translated').or(eq(nil))
                expect(JSON.parse(response.body)['ingredients'][0]['optional']).to eq(false).or(eq(true))

                expect(JSON.parse(response.body)['ingredients'][1]['id']).to eq(ingredient_1.id).or(eq(ingredient_2.id)).or(eq(ingredient_3.id))
                expect(JSON.parse(response.body)['ingredients'][1]['recipe_id']).to eq(recipe.id)
                expect(JSON.parse(response.body)['ingredients'][1]['amount']).to eq('1').or(eq('100')).or(eq(nil))
                expect(JSON.parse(response.body)['ingredients'][1]['unit']).to eq('dollop').or(eq('grams')).or(eq(nil))
                expect(JSON.parse(response.body)['ingredients'][1]['food']).to eq('Sheep wisdom').or(eq('Bountiful fruit')).or(eq('Fanciful loot'))
                expect(JSON.parse(response.body)['ingredients'][1]['preparation']).to eq('translated').or(eq(nil))
                expect(JSON.parse(response.body)['ingredients'][1]['optional']).to eq(false).or(eq(true))

                expect(JSON.parse(response.body)['ingredients'][2]['id']).to eq(ingredient_1.id).or(eq(ingredient_2.id)).or(eq(ingredient_3.id))
                expect(JSON.parse(response.body)['ingredients'][2]['recipe_id']).to eq(recipe.id)
                expect(JSON.parse(response.body)['ingredients'][2]['amount']).to eq('1').or(eq('100')).or(eq(nil))
                expect(JSON.parse(response.body)['ingredients'][2]['unit']).to eq('dollop').or(eq('grams')).or(eq(nil))
                expect(JSON.parse(response.body)['ingredients'][2]['food']).to eq('Sheep wisdom').or(eq('Bountiful fruit')).or(eq('Fanciful loot'))
                expect(JSON.parse(response.body)['ingredients'][2]['preparation']).to eq('translated').or(eq(nil))
                expect(JSON.parse(response.body)['ingredients'][2]['optional']).to eq(false).or(eq(true))

                expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
                expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
              end

              it 'returns 200' do
                patch :update, params: params, format: :json
                expect(response).to have_http_status(:ok)
              end
            end

            context 'multiple ingredients are updated' do
              let(:params) { { id: recipe.id, recipe: { name: 'Eggs been a dick', process: 'Dress egg in Burberry', photo: test_photo_2, ingredients_attributes: [ ingredient_1_params, ingredient_2_params ] } } }
              let(:ingredient_1_params) { { id: ingredient_1.id, amount: '1', unit: nil, food: 'Egg', preparation: 'Smoked while in womb', optional: false } }
              let(:ingredient_2_params) { { id: ingredient_2.id, amount: 'One', unit: 'whole', food: 'Tartan baseball cap', preparation: 'peaked', optional: true } }
              it 'updates the recipe' do
                expect(recipe.name).to eq('Food with food on top')
                expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
                expect(recipe.photo.url).to include('test-photo.jpg')
                expect(recipe.state).to eq('approved')
                patch :update, params: params, format: :json
                expect(recipe.reload.name).to eq('Eggs been a dick')
                expect(recipe.process).to eq('Dress egg in Burberry')
                expect(recipe.photo.url).to include('test-photo-2.jpg')
                expect(recipe.state).to eq('incomplete')
              end

              it 'does not create any ingredients' do
                expect { patch :update, params: params, format: :json }.to change(Ingredient, :count).by(0)
                expect(Ingredient.count).to eq(3)
              end

              it 'updates the relevant ingredients' do
                expect(ingredient_1.amount).to eq('Some')
                expect(ingredient_1.unit).to eq(nil)
                expect(ingredient_1.food).to eq('Green leaves')
                expect(ingredient_1.preparation).to eq('Shredded')
                expect(ingredient_1.optional).to eq(false)
                expect(ingredient_2.amount).to eq('100')
                expect(ingredient_2.unit).to eq('grams')
                expect(ingredient_2.food).to eq('Bountiful fruit')
                expect(ingredient_2.preparation).to eq(nil)
                expect(ingredient_2.optional).to eq(true)
                patch :update, params: params, format: :json
                expect(ingredient_1.reload.amount).to eq('1')
                expect(ingredient_1.unit).to eq(nil)
                expect(ingredient_1.food).to eq('Egg')
                expect(ingredient_1.preparation).to eq('Smoked while in womb')
                expect(ingredient_1.optional).to eq(false)
                expect(ingredient_2.reload.amount).to eq('One')
                expect(ingredient_2.unit).to eq('whole')
                expect(ingredient_2.food).to eq('Tartan baseball cap')
                expect(ingredient_2.preparation).to eq('peaked')
                expect(ingredient_2.optional).to eq(true)
              end

              it 'returns the recipe and the three ingredients' do
                patch :update, params: params, format: :json
                expect(JSON.parse(response.body)['name']).to eq('Eggs been a dick')
                expect(JSON.parse(response.body)['process']).to eq('Dress egg in Burberry')
                expect(JSON.parse(response.body)['photo']['url']).to include('test-photo-2.jpg')

                expect(JSON.parse(response.body)['ingredients'].count).to eq(3)

                expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Egg').or(eq('Tartan baseball cap')).or(eq('Fanciful loot'))
                expect(JSON.parse(response.body)['ingredients'][1]['food']).to eq('Egg').or(eq('Tartan baseball cap')).or(eq('Fanciful loot'))
                expect(JSON.parse(response.body)['ingredients'][2]['food']).to eq('Egg').or(eq('Tartan baseball cap')).or(eq('Fanciful loot'))

                expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
                expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
              end

              it 'returns 200' do
                patch :update, params: params, format: :json
                expect(response).to have_http_status(:ok)
              end
            end
          end

          context '_destroy is passed-in with ingreident' do
            let(:params) { { id: recipe.id, recipe: { name: 'Human beans', process: 'Serve with rice', photo: test_photo_2, ingredients_attributes: [ ingredient_1_params, ingredient_2_params ] } } }
            let(:ingredient_1_params) { { id: ingredient_1.id, amount: '5', unit: 'tin', food: 'Canned mortals', preparation: 'rinsed', optional: false, _destroy: true } }
            let(:ingredient_2_params) { { id: ingredient_2.id, amount: '2', unit: 'cup', food: 'Rice', preparation: 'cooked', optional: true, _destroy: false } }
            it 'updates the recipe' do
              expect(recipe.name).to eq('Food with food on top')
              expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
              expect(recipe.photo.url).to include('test-photo.jpg')
              expect(recipe.state).to eq('approved')
              patch :update, params: params, format: :json
              expect(recipe.reload.name).to eq('Human beans')
              expect(recipe.process).to eq('Serve with rice')
              expect(recipe.photo.url).to include('test-photo-2.jpg')
              expect(recipe.state).to eq('incomplete')
            end

            it 'destroys one ingredient' do
              expect { patch :update, params: params, format: :json }.to change(Ingredient, :count).by(-1)
              expect(Ingredient.count).to eq(2)
            end

            it 'destroys the _destroy truthy ingredient' do
              expect(ingredient_1.food).to eq('Green leaves')
              patch :update, params: params, format: :json
              expect { ingredient_1.reload.food }.to raise_error(ActiveRecord::RecordNotFound)
            end

            it 'updates the _destroy falsey ingredient' do
              expect(ingredient_2.food).to eq('Bountiful fruit')
              patch :update, params: params, format: :json
              expect(ingredient_2.reload.food).to eq('Rice')
            end

            it 'returns the recipe and the two remaining ingredients' do
              patch :update, params: params, format: :json
              expect(JSON.parse(response.body)['name']).to eq('Human beans')
              expect(JSON.parse(response.body)['process']).to eq('Serve with rice')
              expect(JSON.parse(response.body)['photo']['url']).to include('test-photo-2.jpg')

              expect(JSON.parse(response.body)['ingredients'].count).to eq(2)

              expect(JSON.parse(response.body)['ingredients'][0]['food']).to eq('Rice').or(eq('Fanciful loot'))
              expect(JSON.parse(response.body)['ingredients'][1]['food']).to eq('Rice').or(eq('Fanciful loot'))

              expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
              expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
            end

            it 'returns 200' do
              patch :update, params: params, format: :json
              expect(response).to have_http_status(:ok)
            end
          end
        end

        context 'update is not successful' do
          let(:params) { { id: recipe.id, recipe: { name: 'Case idea', process: 'Think hard about your current predicament', photo: test_photo_2 } } }
          before { allow_any_instance_of(Recipe).to receive(:update).and_return(false) }
          it 'does not update the recipe' do
            expect(recipe.name).to eq('Food with food on top')
            patch :update, params: params, format: :json
            expect(recipe.reload.name).to eq('Food with food on top')
          end

          it 'returns errors' do
            patch :update, params: params, format: :json
            expect(JSON.parse(response.body)).to eq('errors' => [])
          end

          it 'returns 422' do
            patch :update, params: params, format: :json
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'user is admin' do
        let(:admin) { create(:user, admin: true) }
        let(:headers) { { 'X-User-Email' => admin.email, 'X-User-Token' => admin.authentication_token } }
        let(:params) { { id: recipe.id, recipe: { name: 'Flaming young', process: 'Mix juvenile with beelzebub', photo: test_photo_2 } } }
        it 'updates the recipe' do
          expect(recipe.name).to eq('Food with food on top')
          expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
          expect(recipe.photo.url).to include('test-photo.jpg')
          expect(recipe.state).to eq('approved')
          patch :update, params: params, format: :json
          expect(recipe.reload.name).to eq('Flaming young')
          expect(recipe.process).to eq('Mix juvenile with beelzebub')
          expect(recipe.photo.url).to include('test-photo-2.jpg')
          expect(recipe.state).to eq('incomplete')
        end

        it 'returns the amended recipe' do
          patch :update, params: params, format: :json
          expect(JSON.parse(response.body)['name']).to eq('Flaming young')
          expect(JSON.parse(response.body)['process']).to eq('Mix juvenile with beelzebub')
          expect(JSON.parse(response.body)['photo']['url']).to include('test-photo-2.jpg')

          expect(JSON.parse(response.body)['ingredients'].count).to eq(3)

          expect(JSON.parse(response.body)['author']['id']).to eq(user.id)
          expect(JSON.parse(response.body)['author']['username']).to eq('steve_the_sofa')
        end

        it 'returns 200' do
          patch :update, params: params, format: :json
          expect(response).to have_http_status(:ok)
        end
      end

      context 'user is imposter' do
        let(:imposter) { create(:user, admin: false) }
        let(:headers) { { 'X-User-Email' => imposter.email, 'X-User-Token' => imposter.authentication_token } }
        let(:params) { { id: recipe.id, recipe: { name: "Farmer John's cheese", process: "Break into John's house. Raid fridge", photo: test_photo_2 } } }
        it 'does not update the recipe' do
          expect(recipe.name).to eq('Food with food on top')
          expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
          expect(recipe.photo.url).to include('test-photo.jpg')
          expect(recipe.state).to eq('approved')
          patch :update, params: params, format: :json
          expect(recipe.reload.name).to eq('Food with food on top')
          expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
          expect(recipe.photo.url).to include('test-photo.jpg')
          expect(recipe.state).to eq('approved')
        end

        it 'returns 401' do
          patch :update, params: params, format: :json
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'user does not exist' do
        let(:headers) { { 'X-User-Email' => 'youcantseeme@wot.umm', 'X-User-Token' => '98765' } }
        let(:params) { { id: recipe.id, recipe: { name: "Can't elope", process: 'Get caught by wife', photo: test_photo_2 } } }
        it 'does not update the recipe' do
          expect(recipe.name).to eq('Food with food on top')
          expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
          expect(recipe.photo.url).to include('test-photo.jpg')
          expect(recipe.state).to eq('approved')
          patch :update, params: params, format: :json
          expect(recipe.reload.name).to eq('Food with food on top')
          expect(recipe.process).to eq('Put all the food into a bowl of food, mix well, then top with food')
          expect(recipe.photo.url).to include('test-photo.jpg')
          expect(recipe.state).to eq('approved')
        end

        it 'returns 401' do
          patch :update, params: params, format: :json
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'recipe does not exist' do
      let(:params) { { id: 9999, recipe: { name: 'Cow zone', process: 'Enter field', photo: test_photo_2 } } }
      it 'returns 404' do
        patch :update, params: params, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { request.headers.merge!(headers) }
    let(:headers) { { 'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token } }
    context 'recipe exists' do
      context 'user is recipe owner' do
        it 'destroys one recipe' do
          expect { delete :destroy, params: { id: recipe.id } }.to change(Recipe, :count).by(-1)
        end

        it 'destroys the correct recipe' do
          expect { recipe }.not_to raise_error
          delete :destroy, params: { id: recipe.id }
          expect { recipe.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'returns 204' do
          delete :destroy, params: { id: recipe.id }
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'user is admin' do
        let(:admin) { create(:user, admin: true) }
        let(:headers) { { 'X-User-Email' => admin.email, 'X-User-Token' => admin.authentication_token } }
        it 'destroys one recipe' do
          expect { delete :destroy, params: { id: recipe.id } }.to change(Recipe, :count).by(-1)
        end

        it 'destroys the correct recipe' do
          expect { recipe }.not_to raise_error
          delete :destroy, params: { id: recipe.id }
          expect { recipe.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'returns 204' do
          delete :destroy, params: { id: recipe.id }
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'user is imposter' do
        let(:imposter) { create(:user, admin: false) }
        let(:headers) { { 'X-User-Email' => imposter.email, 'X-User-Token' => imposter.authentication_token } }
        it 'does not destroy any recipes' do
          expect { delete :destroy, params: { id: recipe.id } }.to change(Recipe, :count).by(0)
        end

        it 'does not raise a RecordNotFound error' do
          expect { recipe }.not_to raise_error
          delete :destroy, params: { id: recipe.id }
          expect { recipe.reload }.not_to raise_error
        end

        it 'returns 401' do
          delete :destroy, params: { id: recipe.id }
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'user does not exist' do
        let(:headers) { { 'X-User-Email' => 'whodis@dooby.scoo', 'X-User-Token' => '654321' } }
        it 'does not destroy any recipes' do
          expect { delete :destroy, params: { id: recipe.id } }.to change(Recipe, :count).by(0)
        end

        it 'does not raise a RecordNotFound error' do
          expect { recipe }.not_to raise_error
          delete :destroy, params: { id: recipe.id }
          expect { recipe.reload }.not_to raise_error
        end

        it 'returns 302' do
          delete :destroy, params: { id: recipe.id }
          expect(response).to have_http_status(:found)
        end
      end
    end

    context 'recipe does not exist' do
      it 'does not destroy any recipes' do
        expect { delete :destroy, params: { id: 9999 } }.to change(Recipe, :count).by(0)
      end

      it 'returns 404' do
        delete :destroy, params: { id: 9999 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
