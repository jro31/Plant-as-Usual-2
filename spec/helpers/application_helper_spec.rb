require 'rails_helper'

describe ApplicationHelper do
  helper do
    def user_signed_in?
      current_user.present?
    end
  end

  let!(:current_user) { create(:user, dark_mode: true) }

  describe '#component_classes(component)' do
    context 'user is not signed-in' do
      let!(:current_user) { nil }
      it 'returns component and component-light-mode' do
        expect(component_classes('navbar')).to eq('navbar navbar-light-mode')
      end
    end

    context 'current_user.dark_mode is true' do
      it 'returns component and component-dark-mode' do
        expect(component_classes('navbar')).to eq('navbar navbar-dark-mode')
      end
    end

    context 'current_user.dark_mode is false' do
      let!(:current_user) { create(:user, dark_mode: false) }
      it 'returns component and component-light-mode' do
        expect(component_classes('navbar')).to eq('navbar navbar-light-mode')
      end
    end
  end

  describe '#display_mode(element)' do
    context 'user is not signed-in' do
      let!(:current_user) { nil }
      it 'returns light-mode' do
        expect(display_mode('body')).to eq('body-light-mode')
      end
    end

    context 'current_user.dark_mode is true' do
      it 'returns dark-mode' do
        expect(display_mode('body')).to eq('body-dark-mode')
      end
    end

    context 'current_user.dark_mode is false' do
      let!(:current_user) { create(:user, dark_mode: false) }
      it 'returns light-mode' do
        expect(display_mode('body')).to eq('body-light-mode')
      end
    end
  end

  describe '#page_title' do
    context 'action is pages#home' do
      before do
        allow(self).to receive(:controller_name) { 'pages' }
        allow(self).to receive(:action_name) { 'home' }
      end
      it { expect(page_title).to eq('Plant as Usual - Plant based recipes') }
    end

    context 'action is not pages#home' do
      context '@recipe exists' do
        before { self.instance_variable_set(:@recipe, recipe) }
        context 'recipe name exists' do
          let(:recipe) { create(:recipe, name: 'Wholewheat pizza') }
          it { expect(page_title).to eq('Wholewheat pizza - Plant as Usual') }
        end

        context 'recipe name does not exist' do
          let(:recipe) { create(:recipe, name: nil) }
          it { expect(page_title).to eq('Plant as Usual') }
        end
      end

      context '@recipe does not exist' do
        context 'action is recipes#index' do
          before do
            allow(self).to receive(:controller_name) { 'recipes' }
            allow(self).to receive(:action_name) { 'index' }
          end
          context '@recipe_filter exists' do
            context '@recipe_filter is user_recipes' do
              before { self.instance_variable_set(:@recipe_filter, 'user_recipes') }
              context '@searched_for_user_id exists' do
                context '@searched_for_user_id is the current user id' do
                  before { self.instance_variable_set(:@searched_for_user_id, current_user.id) }
                  it { expect(page_title).to eq('My recipes - Plant as Usual') }
                end

                context '@searched_for_user_id is not the current user id' do
                  let(:imposter_user) { create(:user, username: 'the_great_jethro') }
                  before { self.instance_variable_set(:@searched_for_user_id, imposter_user.id) }
                  it { expect(page_title).to eq('the_great_jethro\'s recipes - Plant as Usual') }
                end
              end

              context '@searched_for_user_id is nil' do
                it { expect(page_title).to eq('Plant as Usual') }
              end
            end

            context '@recipe_filter is user_favourites' do
              before { self.instance_variable_set(:@recipe_filter, 'user_favourites') }
              it { expect(page_title).to eq('Favourite recipes - Plant as Usual') }
            end

            context '@recipe_filter is search' do
              before { self.instance_variable_set(:@recipe_filter, 'search') }
              context '@search_query exists' do
                before { self.instance_variable_set(:@search_query, 'avocado') }
                it { expect(page_title).to eq('Avocado recipes - Plant as Usual') }
              end

              context '@search_query is an empty string' do
                before { self.instance_variable_set(:@search_query, '') }
                it { expect(page_title).to eq('Plant as Usual') }
              end

              context '@search_query is nil' do
                it { expect(page_title).to eq('Plant as Usual') }
              end
            end
          end

          context '@recipe_filter does not exist' do
            it { expect(page_title).to eq('Plant as Usual') }
          end
        end

        context 'action is sessions#new' do
          before do
            allow(self).to receive(:controller_name) { 'sessions' }
            allow(self).to receive(:action_name) { 'new' }
          end
          it { expect(page_title).to eq('Sign in - Plant as Usual') }
        end

        context 'action is registrations#new' do
          before do
            allow(self).to receive(:controller_name) { 'registrations' }
            allow(self).to receive(:action_name) { 'new' }
          end
          it { expect(page_title).to eq('Sign up - Plant as Usual') }
        end

        context 'action is something else' do
          it { expect(page_title).to eq('Plant as Usual') }
        end
      end
    end
  end
end
