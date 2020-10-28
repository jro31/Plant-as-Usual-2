require 'rails_helper'

describe ApplicationHelper do
  helper do
    def user_signed_in?
      current_user.present?
    end
  end

  let!(:current_user) { create(:user, dark_mode: true) }

  describe '#display_mode' do
      context 'user is not signed-in' do
      let!(:current_user) { nil }
      it 'returns light-mode' do
        expect(display_mode).to eq('light-mode')
      end
    end

    context 'current_user.dark_mode is true' do
      it 'returns dark-mode' do
        expect(display_mode).to eq('dark-mode')
      end
    end

    context 'current_user.dark_mode is false' do
      let!(:current_user) { create(:user, dark_mode: false) }
      it 'returns light-mode' do
        expect(display_mode).to eq('light-mode')
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

  describe '#is_or_are' do
    context 'amount is an integer' do
      it { expect(is_or_are(-1)).to eq('are') }
      it { expect(is_or_are(0)).to eq('are') }
      it { expect(is_or_are(1)).to eq('is') }
      it { expect(is_or_are(2)).to eq('are') }
    end

    context 'amount is a float' do
      it { expect(is_or_are(-1.0)).to eq('are') }
      it { expect(is_or_are(0.1)).to eq('are') }
      it { expect(is_or_are(1.0)).to eq('is') }
      it { expect(is_or_are(1.1)).to eq('are') }
      it { expect(is_or_are(2.0)).to eq('are') }
    end

    context 'amount is other data type' do
      it { expect { is_or_are('1') }.to raise_error(ApplicationHelper::AmountIsNotNumber) }
      it { expect { is_or_are([1]) }.to raise_error(ApplicationHelper::AmountIsNotNumber) }
    end
  end

  describe '#no_or_number' do
    context 'amount is an integer' do
      it { expect(no_or_number(-1)).to eq(-1) }
      it { expect(no_or_number(0)).to eq('no') }
      it { expect(no_or_number(1)).to eq(1) }
    end

    context 'amount is a float' do
      it { expect(no_or_number(-1.0)).to eq(-1) }
      it { expect(no_or_number(-0.1)).to eq(-0.1) }
      it { expect(no_or_number(0.0)).to eq('no') }
      it { expect(no_or_number(0.1)).to eq(0.1) }
      it { expect(no_or_number(1.0)).to eq(1) }
    end

    context 'amount is other data type' do
      it { expect { no_or_number('1') }.to raise_error(ApplicationHelper::AmountIsNotNumber) }
      it { expect { no_or_number([1]) }.to raise_error(ApplicationHelper::AmountIsNotNumber) }
    end
  end

  describe '#number_of_at_symbols' do
    context 'argument is a string' do
      it { expect(number_of_at_symbols('khargatyewbell.com')).to eq(0) }
      it { expect(number_of_at_symbols('Lady Nafia')).to eq(0) }
      it { expect(number_of_at_symbols('darc@savethedeimos.com')).to eq(1) }
      it { expect(number_of_at_symbols('lilia@@lightstone.com')).to eq(2) }
      it { expect(number_of_at_symbols(' @   @      @ Bebedora @  ')).to eq(4) }
    end

    context 'argument is not a string' do
      it { expect { number_of_at_symbols(1234) }.to raise_error(ApplicationHelper::ArgumentIsNotString) }
      it { expect { number_of_at_symbols(5.67) }.to raise_error(ApplicationHelper::ArgumentIsNotString) }
      it { expect { number_of_at_symbols(['Maru']) }.to raise_error(ApplicationHelper::ArgumentIsNotString) }
    end
  end

  describe '#number_of_full_stops' do
    context 'argument is a string' do
      it { expect(number_of_full_stops('deimos@dragonbonevalley')).to eq(0) }
      it { expect(number_of_full_stops('Windalf 4 Nafia')).to eq(0) }
      it { expect(number_of_full_stops('paulette@screwlilia.com')).to eq(1) }
      it { expect(number_of_full_stops('densima@firbles..yum')).to eq(2) }
      it { expect(number_of_full_stops(' ..   .      . Volk @ .  ')).to eq(5) }
    end

    context 'argument is not a string' do
      it { expect { number_of_full_stops(1234) }.to raise_error(ApplicationHelper::ArgumentIsNotString) }
      it { expect { number_of_full_stops(5.67) }.to raise_error(ApplicationHelper::ArgumentIsNotString) }
      it { expect { number_of_full_stops(['Camellia']) }.to raise_error(ApplicationHelper::ArgumentIsNotString) }
    end
  end
end
