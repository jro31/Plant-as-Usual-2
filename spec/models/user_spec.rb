require 'rails_helper'

describe User, type: :model do
  it { should have_many :recipes }
  it { should have_many :user_favourite_recipes }
  it { should have_many :favourites }

  let(:user) { create(:user) }

  describe 'User.favourites' do
    let(:recipe_1) { create(:recipe) }
    let!(:recipe_2) { create(:recipe) }
    let!(:user_favourite_recipe_1) { create(:user_favourite_recipe, user: user, recipe: recipe_1) }
    let!(:user_favourite_recipe_2) { create(:user_favourite_recipe, user: user, recipe: recipe_2) }
    it 'returns their favourite recipes' do
      expect(user.favourites).to include(recipe_1, recipe_2)
    end
  end

  describe 'destroying a user destroys their recipes' do
    let!(:recipe) { create(:recipe, id: 999, user: user) }
    it 'destroys the recipe' do
      expect(Recipe.find(999)).to eq(recipe)
      user.destroy
      expect { Recipe.find(999) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'destroying a user destroys associated user_favourite_recipes' do
    let(:recipe) { create(:recipe) }
    let!(:user_favourite_recipe) { create(:user_favourite_recipe, id: 111, user: user, recipe: recipe) }
    it 'destroys the user_favourite_recipe' do
      expect(UserFavouriteRecipe.find(111)).to eq(user_favourite_recipe)
      user.destroy
      expect { UserFavouriteRecipe.find(111) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'validations' do
    it { expect(user).to be_valid }
    describe 'username' do
      describe 'uniqueness' do
        let!(:other_user) { create(:user, username: 'patronus') }
        context 'username is unique' do
          it 'is valid' do
            user.username = 'animagus'
            expect(user).to be_valid
          end
        end

        context 'username already exists' do
          it 'is not valid' do
            user.username = 'patronus'
            expect(user).not_to be_valid
            expect(user.errors.messages[:username]).to include('has already been taken')
          end
        end

        context 'username already exists case insensitively' do
          it 'is not valid' do
            user.username = 'Patronus'
            expect(user).not_to be_valid
            expect(user.errors.messages[:username]).to include('has already been taken')
          end
        end
      end

      describe 'length' do
        context 'username is nil' do
          it 'is not valid' do
            user.username = nil
            expect(user).not_to be_valid
            expect(user.errors.messages[:username]).to include('is too short (minimum is 3 characters)')
          end
        end

        context 'username is an empty string' do
          it 'is not valid' do
            user.username = ""
            expect(user).not_to be_valid
            expect(user.errors.messages[:username]).to include('is too short (minimum is 3 characters)')
          end
        end

        context 'username is two characters' do
          it 'is not valid' do
            user.username = 'Hi'
            expect(user).not_to be_valid
            expect(user.errors.messages[:username]).to include('is too short (minimum is 3 characters)')
          end
        end

        context 'username is three characters' do
          it 'is valid' do
            user.username = 'Hog'
            expect(user).to be_valid
          end
        end

        context 'username is sixteen characters' do
          it 'is valid' do
            user.username = 'sixteencharacter'
            expect(user).to be_valid
          end
        end

        context 'username is seventeen characters' do
          it 'is not valid' do
            user.username = 'seventeencharacte'
            expect(user).not_to be_valid
            expect(user.errors.messages[:username]).to include('is too long (maximum is 16 characters)')
          end
        end

        context 'username contains spaces' do
          it 'is not valid' do
            user.username = 'Hag rid'
            expect(user).not_to be_valid
            expect(user.errors.messages[:username]).to include('cannot contain spaces')
          end

          it 'is not valid' do
            user.username = ' fleurdelacour'
            expect(user).not_to be_valid
            expect(user.errors.messages[:username]).to include('cannot contain spaces')
          end

          it 'is not valid' do
            user.username = 'wormtail '
            expect(user).not_to be_valid
            expect(user.errors.messages[:username]).to include('cannot contain spaces')
          end
        end
      end
    end

    describe 'email' do
      describe 'presence' do
        context 'email is nil' do
          it 'is not valid' do
            user.email = nil
            expect(user).not_to be_valid
            expect(user.errors.messages[:email]).to include("can't be blank")
          end
        end

        context 'email is an empty string' do
          it 'is not valid' do
            user.email = ""
            expect(user).not_to be_valid
            expect(user.errors.messages[:email]).to include("can't be blank")
          end
        end

        context 'email is not an email address' do
          context 'it does not contain @' do
            it 'is not valid' do
              user.email = 'dumbledore.com'
              expect(user).not_to be_valid
              expect(user.errors.messages[:email]).to include('is invalid')
            end
          end

          context 'is does not contain .' do
            # Not sure why this is passing
            xit 'is not valid' do
              user.email = 'hermione@hogwarts'
              expect(user).not_to be_valid
              expect(user.errors.messages[:email]).to include('is invalid')
            end
          end
        end

        context 'email is correct' do
          it 'is valid' do
            user.email = 'peeves@hogwarts.com'
            expect(user).to be_valid
          end
        end
      end

      describe 'uniqueness' do
        let!(:other_user) { create(:user, email: 'firebolt@quidditch.wiz') }
        context 'email is unique' do
          it 'is valid' do
            user.email = 'voldemort@darklord.avadakedavra'
            expect(user).to be_valid
          end
        end

        context 'email is not unique' do
          it 'is not valid' do
            user.email = 'firebolt@quidditch.wiz'
            expect(user).not_to be_valid
            expect(user.errors.messages[:email]).to include('has already been taken')
          end
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'after_create' do
      describe '#send_sign_up_slack_message' do
        context 'on create' do
          subject { build(:user, email: 'tomriddle@hogwarts.edu', username: 'voldewho?') }
          it 'calls SendSlackMessageJob with the correct message' do
            expect(SendSlackMessageJob).to receive(:perform_later).with('A new user has signed-up, username: voldewho?, email: tomriddle@hogwarts.edu', nature: 'celebrate').once
            subject.save
          end
        end

        context 'on update' do
          subject! { create(:user, dark_mode: false) }
          it 'does not call SendSlackMessageJob' do
            expect(SendSlackMessageJob).to receive(:perform_later).never
            subject.update(dark_mode: true)
          end
        end
      end
    end
  end
end
