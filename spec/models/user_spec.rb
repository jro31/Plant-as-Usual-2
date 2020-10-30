require 'rails_helper'

describe User, type: :model do
  it { should have_many :recipes }
  it { should have_many :user_favourite_recipes }
  it { should have_many :favourites }

  let(:user) { create(:user) }

  describe 'EDITABLE_COLUMNS' do
    it 'returns a hash of editable columns' do
      expect(User::EDITABLE_COLUMNS).to eq({
        username: 'username',
        email: 'email',
        password: 'password',
        twitter_handle: 'twitter_handle',
        instagram_handle: 'instagram_handle',
        website_url: 'website_url'
      })
    end
  end

  describe 'acts_as_token_authenticatable' do
    context 'on create' do
      subject { build(:user) }
      it 'gives the user an authentication token' do
        expect(subject.authentication_token).to eq(nil)
        subject.save
        expect(subject.authentication_token).not_to eq(nil)
      end
    end

    context 'on save' do
      subject { create(:user) }
      it 'gives the user an authentication token' do
        subject.authentication_token = nil
        expect(subject.authentication_token).to eq(nil)
        subject.save
        expect(subject.authentication_token).not_to eq(nil)
      end
    end
  end

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
              expect(user.errors.messages[:email]).to include("must contain exactly one '@'")
            end
          end

          context 'it contains two @ symbols' do
            it 'is not valid' do
              user.email = 'remus@@wolflife.com'
              expect(user).not_to be_valid
              expect(user.errors.messages[:email]).to include('is invalid')
              expect(user.errors.messages[:email]).to include("must contain exactly one '@'")
            end

            it 'is not valid' do
              user.email = 'cho@chang@influencer.love'
              expect(user).not_to be_valid
              expect(user.errors.messages[:email]).to include('is invalid')
              expect(user.errors.messages[:email]).to include("must contain exactly one '@'")
            end
          end

          context 'is does not contain .' do
            it 'is not valid' do
              user.email = 'hermione@hogwarts'
              expect(user).not_to be_valid
              expect(user.errors.messages[:email]).to include('must contain a full stop')
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

    describe 'twitter_handle' do
      it 'is valid' do
        user.twitter_handle = 'padfoot'
        expect(user).to be_valid
      end

      context 'it contains spaces' do
        it 'is not valid' do
          user.twitter_handle = 'pad foot'
          expect(user).not_to be_valid
          expect(user.errors.messages[:twitter_handle]).to include('cannot contain spaces')
        end
      end
    end

    describe 'instagram_handle' do
      it 'is valid' do
        user.instagram_handle = 'Prongs'
        expect(user).to be_valid
      end

      context 'it contains spaces' do
        it 'is not valid' do
          user.instagram_handle = 'P rongs'
          expect(user).not_to be_valid
          expect(user.errors.messages[:instagram_handle]).to include('cannot contain spaces')
        end
      end
    end

    describe 'website_url' do
      it 'is valid' do
        user.website_url = 'www.dumbledoresarmy.org'
        expect(user).to be_valid
      end

      context 'it contains spaces' do
        it 'is not valid' do
          user.website_url = 'www.dumbledores army.org'
          expect(user).not_to be_valid
          expect(user.errors.messages[:website_url]).to include('cannot contain spaces')
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'before_validation' do
      describe '#strip_whitespace' do
        describe 'on create' do
          describe 'username' do
            subject { build(:user, username: ' dobby-sir ') }
            it 'removes leading and trailing spaces' do
              subject.save
              expect(subject.username).to eq('dobby-sir')
            end
          end

          describe 'email' do
            subject { build(:user, email: ' dobby@elflivesmatter.org ') }
            it 'removes leading and trailing spaces' do
              subject.save
              expect(subject.email).to eq('dobby@elflivesmatter.org')
            end
          end

          describe 'twitter_handle' do
            subject { build(:user, twitter_handle: '  dobbysir ') }
            it 'removes leading and trailing spaces' do
              subject.save
              expect(subject.twitter_handle).to eq('dobbysir')
            end
          end

          describe 'instagram_handle' do
            subject { build(:user, instagram_handle: '  elftravels  ') }
            it 'removes leading and trailing spaces' do
              subject.save
              expect(subject.instagram_handle).to eq('elftravels')
            end
          end

          describe 'website_url' do
            subject { build(:user, website_url: '  www.freeatlast.elf  ') }
            it 'removes leading and trailing spaces' do
              subject.save
              expect(subject.website_url).to eq('www.freeatlast.elf')
            end
          end
        end

        describe 'on update' do
          describe 'username' do
            it 'removes leading and trailing spaces' do
              user.update(username: '  Winky  ')
              expect(user.username).to eq('Winky')
            end
          end

          describe 'email' do
            it 'removes leading and trailing spaces' do
              user.update(email: '  winky@malfoyresidence.com   ')
              expect(user.email).to eq('winky@malfoyresidence.com')
            end
          end

          describe 'twitter_handle' do
            it 'removes leading and trailing spaces' do
              user.update(twitter_handle: '  @goodelf   ')
              expect(user.twitter_handle).to eq('goodelf')
            end
          end

          describe 'instagram_handle' do
            it 'removes leading and trailing spaces' do
              user.update(instagram_handle: '  @cleaning-pics   ')
              expect(user.instagram_handle).to eq('cleaning-pics')
            end
          end

          describe 'website_url' do
            it 'removes leading and trailing spaces' do
              user.update(website_url: '    www.elvendiaries.com   ')
              expect(user.website_url).to eq('www.elvendiaries.com')
            end
          end
        end
      end

      describe '#replace_empty_strings_with_nil' do
        describe 'on create' do
          describe 'twitter handle' do
            subject { build(:user, twitter_handle: '') }
            it 'saves as nil' do
              subject.save
              expect(subject.twitter_handle).to eq(nil)
            end
          end

          describe 'instagram handle' do
            subject { build(:user, instagram_handle: '') }
            it 'saves as nil' do
              subject.save
              expect(subject.instagram_handle).to eq(nil)
            end
          end

          describe 'website url' do
            subject { build(:user, website_url: '') }
            it 'saves as nil' do
              subject.save
              expect(subject.website_url).to eq(nil)
            end
          end
        end

        describe 'on update' do
          subject { create(:user) }
          describe 'twitter handle' do
            it 'saves as nil' do
              subject.update(twitter_handle: '')
              expect(subject.twitter_handle).to eq(nil)
            end
          end

          describe 'instagram handle' do
            it 'saves as nil' do
              subject.update(instagram_handle: '')
              expect(subject.instagram_handle).to eq(nil)
            end
          end

          describe 'website url' do
            it 'saves as nil' do
              subject.update(website_url: '')
              expect(subject.website_url).to eq(nil)
            end
          end
        end
      end

      describe '#sanitize_social_media_handles' do
        describe 'on create' do
          describe 'twitter handle' do
            context 'starts with @' do
              subject { build(:user, twitter_handle: '@chosen_one') }
              it 'removes the @' do
                subject.save
                expect(subject.twitter_handle).to eq('chosen_one')
              end
            end

            context 'does not start with @' do
              subject { build(:user, twitter_handle: 'chosen_one') }
              it 'does not change anything' do
                subject.save
                expect(subject.twitter_handle).to eq('chosen_one')
              end
            end
          end

          describe 'instagram handle' do
            context 'starts with @' do
              subject { build(:user, instagram_handle: '@potter_pix') }
              it 'removes the @' do
                subject.save
                expect(subject.instagram_handle).to eq('potter_pix')
              end
            end

            context 'does not start with @' do
              subject { build(:user, instagram_handle: 'potter_pix') }
              it 'does not change anything' do
                subject.save
                expect(subject.instagram_handle).to eq('potter_pix')
              end
            end
          end
        end

        describe 'on update' do
          subject { create(:user, twitter_handle: nil, instagram_handle: nil) }
          describe 'twitter handle' do
            context 'starts with @' do
              it 'removes the @' do
                subject.update(twitter_handle: '@boy_who_lived')
                expect(subject.twitter_handle).to eq('boy_who_lived')
              end
            end

            context 'does not start with @' do
              it 'does not change anything' do
                subject.update(twitter_handle: 'boy_who_lived')
                expect(subject.twitter_handle).to eq('boy_who_lived')
              end
            end
          end

          describe 'instagram handle' do
            context 'starts with @' do
              it 'removes the @' do
                subject.update(instagram_handle: '@dumbledores_army')
                expect(subject.instagram_handle).to eq('dumbledores_army')
              end
            end

            context 'does not start with @' do
              it 'does not change anything' do
                subject.update(instagram_handle: 'dumbledores_army')
                expect(subject.instagram_handle).to eq('dumbledores_army')
              end
            end
          end
        end
      end
    end

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

  describe 'editable_column_labels' do
    it 'returns the editable column labels' do
      expect(User.editable_column_labels).to eq(
        {
          'username' => 'username',
          'email' => 'email',
          'password' => 'password',
          'twitter_handle' => 'Twitter handle',
          'instagram_handle' => 'Instagram username',
          'website_url' => 'personal website'
        }
      )
    end
  end

  describe 'editable_column_hints' do
    it 'returns the editable column hints' do
      expect(User.editable_column_hints).to eq(
        {
          'username' => 'This will be visible to other users.',
          'email' => nil,
          'twitter_handle' => 'Optional. This will be visible to other users.',
          'instagram_handle' => 'Optional. This will be visible to other users.',
          'website_url' => 'Optional. This will be visible to other users.'
        }
      )
    end
  end

  describe '#editable_column_placeholders' do
    it 'returns the editable column placeholders' do
      expect(User.editable_column_placeholders).to eq(
        {
          'username' => nil,
          'email' => nil,
          'twitter_handle' => '@plantasusual',
          'instagram_handle' => 'plantasusual',
          'website_url' => 'https://www.plantasusual.com/'
        }
      )
    end
  end
end
