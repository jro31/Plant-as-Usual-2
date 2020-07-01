require 'rails_helper'

describe Recipe, type: :model do
  it { should belong_to :user }
  it { should have_many :ingredients }

  describe 'validations' do
    describe '#validate_not_currently_featured' do
      # COMPELTE THIS
    end

    describe '#validate_number_of_recipes_of_the_day' do
      # COMPLETE THIS
    end

    describe '#validate_number_of_featured_recipes' do
      # COMPLETE THIS
    end
  end

  describe 'callbacks' do
    describe 'after_save' do
      describe '#update_state_updated_at' do
        # COMPLETE THIS
      end
    end
  end

  describe 'scopes' do
    let!(:incomplete_recipe) { create(:recipe, state: :incomplete) }
    let!(:awaiting_approval_recipe) { create(:recipe, state: :awaiting_approval) }
    let!(:approved_recipe) { create(:recipe, state: :approved) }
    let!(:approved_for_feature_recipe) { create(:recipe, state: :approved_for_feature) }
    let!(:approved_for_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day) }
    let!(:currently_featured_recipe) { create(:recipe, state: :currently_featured) }
    let!(:recipe_of_the_day_as_currently_featured_recipe) { create(:recipe, state: :recipe_of_the_day_as_currently_featured) }
    let!(:current_recipe_of_the_day_recipe) { create(:recipe, state: :current_recipe_of_the_day) }
    let!(:declined_recipe) { create(:recipe, state: :declined) }
    let!(:hidden_recipe) { create(:recipe, state: :hidden) }

    describe '.approved' do
      subject { Recipe.approved }
      it { expect(subject).to include(approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, awaiting_approval_recipe, currently_featured_recipe, recipe_of_the_day_as_currently_featured_recipe, current_recipe_of_the_day_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.approved_for_feature' do
      subject { Recipe.approved_for_feature }
      it { expect(subject).to include(approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, awaiting_approval_recipe, approved_recipe, currently_featured_recipe, recipe_of_the_day_as_currently_featured_recipe, current_recipe_of_the_day_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.approved_for_recipe_of_the_day' do
      subject { Recipe.approved_for_recipe_of_the_day }
      it { expect(subject).to include(approved_for_recipe_of_the_day_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, awaiting_approval_recipe, approved_recipe, approved_for_feature_recipe, currently_featured_recipe, recipe_of_the_day_as_currently_featured_recipe, current_recipe_of_the_day_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.currently_featured' do
      subject { Recipe.currently_featured }
      it { expect(subject).to include(currently_featured_recipe, recipe_of_the_day_as_currently_featured_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, awaiting_approval_recipe, approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe, current_recipe_of_the_day_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.current_recipe_of_the_day' do
      subject { Recipe.current_recipe_of_the_day }
      it { expect(subject).to eq(current_recipe_of_the_day_recipe) }
    end

    describe '.currently_highlighted' do
      subject { Recipe.currently_highlighted }
      it { expect(subject).to include(currently_featured_recipe, recipe_of_the_day_as_currently_featured_recipe, current_recipe_of_the_day_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, awaiting_approval_recipe, approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.awaiting_approval' do
      subject { Recipe.awaiting_approval }
      it { expect(subject).to include(awaiting_approval_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe, currently_featured_recipe, recipe_of_the_day_as_currently_featured_recipe, current_recipe_of_the_day_recipe, declined_recipe, hidden_recipe) }
    end

    describe '.not_hidden' do
      subject { Recipe.not_hidden }
      it { expect(subject).to include(incomplete_recipe, awaiting_approval_recipe, approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe, currently_featured_recipe, recipe_of_the_day_as_currently_featured_recipe, current_recipe_of_the_day_recipe, declined_recipe) }
      it { expect(subject).not_to include(hidden_recipe) }
    end
  end

  describe 'state machine' do
    describe 'events' do
      let(:incomplete_recipe) { create(:recipe, state: :incomplete) }
      let(:awaiting_approval_recipe) { create(:recipe, state: :awaiting_approval) }
      let(:approved_recipe) { create(:recipe, state: :approved) }
      let(:approved_for_feature_recipe) { create(:recipe, state: :approved_for_feature) }
      let(:approved_for_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day) }
      let(:currently_featured_recipe) { create(:recipe, state: :currently_featured) }
      let(:recipe_of_the_day_as_currently_featured_recipe) { create(:recipe, state: :recipe_of_the_day_as_currently_featured) }
      let(:current_recipe_of_the_day_recipe) { create(:recipe, state: :current_recipe_of_the_day) }
      let(:declined_recipe) { create(:recipe, state: :declined) }
      let(:hidden_recipe) { create(:recipe, state: :hidden) }
      let(:all_recipes) { [incomplete_recipe, awaiting_approval_recipe, approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe, currently_featured_recipe, recipe_of_the_day_as_currently_featured_recipe, current_recipe_of_the_day_recipe, declined_recipe, hidden_recipe] }
      before { all_recipes.each { |recipe| recipe.send(event) } }
      describe '.complete' do
        let(:event) { 'complete' }
        it { expect(incomplete_recipe.state).to eq('awaiting_approval') }
        it { expect(awaiting_approval_recipe.state).to eq('awaiting_approval') }
        it { expect(approved_recipe.state).to eq('approved') }
        it { expect(approved_for_feature_recipe.state).to eq('approved_for_feature') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('approved_for_recipe_of_the_day') }
        it { expect(currently_featured_recipe.state).to eq('currently_featured') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('recipe_of_the_day_as_currently_featured') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('current_recipe_of_the_day') }
        it { expect(declined_recipe.state).to eq('declined') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end

      describe '.revised' do
        let(:event) { 'revised' }
        it { expect(incomplete_recipe.state).to eq('incomplete') }
        it { expect(awaiting_approval_recipe.state).to eq('incomplete') }
        it { expect(approved_recipe.state).to eq('incomplete') }
        it { expect(approved_for_feature_recipe.state).to eq('incomplete') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('incomplete') }
        it { expect(currently_featured_recipe.state).to eq('incomplete') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('incomplete') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('incomplete') }
        it { expect(declined_recipe.state).to eq('incomplete') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end

      describe '.approve' do
        let(:event) { 'approve' }
        it { expect(incomplete_recipe.state).to eq('incomplete') }
        it { expect(awaiting_approval_recipe.state).to eq('approved') }
        it { expect(approved_recipe.state).to eq('approved') }
        it { expect(approved_for_feature_recipe.state).to eq('approved_for_feature') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('approved_for_recipe_of_the_day') }
        it { expect(currently_featured_recipe.state).to eq('currently_featured') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('recipe_of_the_day_as_currently_featured') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('current_recipe_of_the_day') }
        it { expect(declined_recipe.state).to eq('declined') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end

      describe '.approve_for_feature' do
        let(:event) { 'approve_for_feature' }
        it { expect(incomplete_recipe.state).to eq('incomplete') }
        it { expect(awaiting_approval_recipe.state).to eq('approved_for_feature') }
        it { expect(approved_recipe.state).to eq('approved') }
        it { expect(approved_for_feature_recipe.state).to eq('approved_for_feature') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('approved_for_recipe_of_the_day') }
        it { expect(currently_featured_recipe.state).to eq('currently_featured') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('recipe_of_the_day_as_currently_featured') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('current_recipe_of_the_day') }
        it { expect(declined_recipe.state).to eq('declined') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end

      describe '.approve_for_recipe_of_the_day' do
        let(:event) { 'approve_for_recipe_of_the_day' }
        it { expect(incomplete_recipe.state).to eq('incomplete') }
        it { expect(awaiting_approval_recipe.state).to eq('approved_for_recipe_of_the_day') }
        it { expect(approved_recipe.state).to eq('approved') }
        it { expect(approved_for_feature_recipe.state).to eq('approved_for_feature') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('approved_for_recipe_of_the_day') }
        it { expect(currently_featured_recipe.state).to eq('currently_featured') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('recipe_of_the_day_as_currently_featured') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('current_recipe_of_the_day') }
        it { expect(declined_recipe.state).to eq('declined') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end

      describe '.feature' do
        let(:event) { 'feature' }
        it { expect(incomplete_recipe.state).to eq('incomplete') }
        it { expect(awaiting_approval_recipe.state).to eq('awaiting_approval') }
        it { expect(approved_recipe.state).to eq('approved') }
        it { expect(approved_for_feature_recipe.state).to eq('currently_featured') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('recipe_of_the_day_as_currently_featured') }
        it { expect(currently_featured_recipe.state).to eq('currently_featured') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('recipe_of_the_day_as_currently_featured') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('current_recipe_of_the_day') }
        it { expect(declined_recipe.state).to eq('declined') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end

      describe '.set_as_recipe_of_the_day' do
        let(:event) { 'set_as_recipe_of_the_day' }
        it { expect(incomplete_recipe.state).to eq('incomplete') }
        it { expect(awaiting_approval_recipe.state).to eq('awaiting_approval') }
        it { expect(approved_recipe.state).to eq('approved') }
        it { expect(approved_for_feature_recipe.state).to eq('approved_for_feature') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('current_recipe_of_the_day') }
        it { expect(currently_featured_recipe.state).to eq('currently_featured') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('recipe_of_the_day_as_currently_featured') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('current_recipe_of_the_day') }
        it { expect(declined_recipe.state).to eq('declined') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end

      describe '.revert_from_highlighted' do
        let(:event) { 'revert_from_highlighted' }
        it { expect(incomplete_recipe.state).to eq('incomplete') }
        it { expect(awaiting_approval_recipe.state).to eq('awaiting_approval') }
        it { expect(approved_recipe.state).to eq('approved') }
        it { expect(approved_for_feature_recipe.state).to eq('approved_for_feature') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('approved_for_recipe_of_the_day') }
        it { expect(currently_featured_recipe.state).to eq('approved_for_feature') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('approved_for_recipe_of_the_day') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('approved_for_recipe_of_the_day') }
        it { expect(declined_recipe.state).to eq('declined') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end

      describe '.decline' do
        let(:event) { 'decline' }
        it { expect(incomplete_recipe.state).to eq('incomplete') }
        it { expect(awaiting_approval_recipe.state).to eq('declined') }
        it { expect(approved_recipe.state).to eq('approved') }
        it { expect(approved_for_feature_recipe.state).to eq('approved_for_feature') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('approved_for_recipe_of_the_day') }
        it { expect(currently_featured_recipe.state).to eq('currently_featured') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('recipe_of_the_day_as_currently_featured') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('current_recipe_of_the_day') }
        it { expect(declined_recipe.state).to eq('declined') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end

      describe '.hide' do
        let(:event) { 'hide' }
        it { expect(incomplete_recipe.state).to eq('hidden') }
        it { expect(awaiting_approval_recipe.state).to eq('hidden') }
        it { expect(approved_recipe.state).to eq('hidden') }
        it { expect(approved_for_feature_recipe.state).to eq('hidden') }
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('hidden') }
        it { expect(currently_featured_recipe.state).to eq('hidden') }
        it { expect(recipe_of_the_day_as_currently_featured_recipe.state).to eq('hidden') }
        it { expect(current_recipe_of_the_day_recipe.state).to eq('hidden') }
        it { expect(declined_recipe.state).to eq('hidden') }
        it { expect(hidden_recipe.state).to eq('hidden') }
      end
    end

    describe 'callbacks' do
      describe 'after_transition' do
        describe '[:currently_featured, :recipe_of_the_day_as_currently_featured] => any' do
          subject { recipe.revert_from_highlighted }
          context 'recipe is currently_featured' do
            let(:recipe) { create(:recipe, state: 'currently_featured') }
            it 'calls set_next_featured_recipe' do
              # COMPLETE THIS
            end
          end

          context 'recipe is recipe_of_the_day_as_currently_featured' do
            let(:recipe) { create(:recipe, state: 'recipe_of_the_day_as_currently_featured') }
            it 'calls set_next_featured_recipe' do
              # COMPLETE THIS
            end
          end

          context 'recipe is something else' do
            let(:recipe) { create(:recipe, state: 'current_recipe_of_the_day') }
            it 'does not call set_next_featured_recipe' do
              # COMPLETE THIS
            end
          end
        end

        describe ':current_recipe_of_the_day => any' do
          subject { recipe.revert_from_highlighted }
          context 'recipe is current_recipe_of_the_day' do
            let(:recipe) { create(:recipe, state: 'current_recipe_of_the_day') }
            it 'calls set_next_recipe_of_the_day' do
              # COMPLETE THIS
            end
          end

          context 'recipe is something else' do
            let(:recipe) { create(:recipe, state: 'recipe_of_the_day_as_currently_featured') }
            it 'does not call set_next_recipe_of_the_day' do
              # COMPLETE THIS
            end
          end
        end
      end
    end
  end

  describe 'class methods' do
    let(:recipe) { create(:recipe) }
    describe '#update_highlighted_recipes' do
      it 'calls update_recipe_of_the_day' do
        # COMPLETE THIS
      end

      it 'calls update_featured_recipes' do
        # COMPLETE THIS
      end
    end

    describe '#update_recipe_of_the_day' do
      let!(:current_recipe_of_the_day) { create(:recipe, state: :current_recipe_of_the_day, last_recipe_of_the_day_at: 1.day.ago) }
      let!(:next_recipe_of_the_day) { create(:recipe, state: :approved_for_recipe_of_the_day, last_recipe_of_the_day_at: nil) }
      subject { Recipe.update_recipe_of_the_day }
      context 'last_recipe_of_the_day_at is less than 23 hours ago' do
        before { current_recipe_of_the_day.update(last_recipe_of_the_day_at: 22.hours.ago) }
        it 'does not change the state of the recipe' do
          subject
          expect(current_recipe_of_the_day.reload.state).to eq('current_recipe_of_the_day')
        end
      end

      context 'last_recipe_of_the_day_at is 23 hours ago or more' do
        before { current_recipe_of_the_day.update(last_recipe_of_the_day_at: 23.hours.ago) }
        it 'updates the state of the recipe to approved_for_recipe_of_the_day' do
          subject
          expect(current_recipe_of_the_day.reload.state).to eq('approved_for_recipe_of_the_day')
        end
      end
    end

    describe '#set_next_recipe_of_the_day' do
      before { Timecop.freeze }
      after { Timecop.return }
      subject { Recipe.set_next_recipe_of_the_day }
      context 'the number of current recipes of the day is less than NUMBER_OF_RECIPES_OF_THE_DAY' do
        context 'next recipe of the day exists' do
          let!(:next_recipe_of_the_day) { create(:recipe, state: :approved_for_recipe_of_the_day) }
          it 'sets the next recipe of the day as recipe of the day' do
            subject
            expect(next_recipe_of_the_day.reload.state).to eq('current_recipe_of_the_day')
          end

          it 'sets last_recipe_of_the_day_at' do
            subject
            expect(next_recipe_of_the_day.reload.last_recipe_of_the_day_at).to eq(Time.now)
          end
        end

        context 'next recipe of the day does not exist' do
          it 'does nothing' do
            expect(subject).to eq(nil)
          end
        end
      end

      context 'the number of current recipes of the day is equal to NUMBER_OF_RECIPES_OF_THE_DAY' do
        let!(:current_recipe_of_the_day) { create(:recipe, state: :current_recipe_of_the_day) }
        it 'does nothing' do
          expect(subject).to eq(nil)
        end
      end
    end

    describe '#next_recipe_of_the_day' do
      let!(:middle_never_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day, last_recipe_of_the_day_at: nil, created_at: 1.week.ago) }
      let!(:oldest_never_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day, last_recipe_of_the_day_at: nil, created_at: 1.month.ago) }
      let!(:newest_never_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day, last_recipe_of_the_day_at: nil, created_at: 1.day.ago) }
      let!(:middle_previous_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day, last_recipe_of_the_day_at: 1.week.ago) }
      let!(:oldest_previous_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day, last_recipe_of_the_day_at: 1.month.ago) }
      let!(:newest_previous_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day, last_recipe_of_the_day_at: 1.day.ago) }
      let!(:not_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_feature, last_recipe_of_the_day_at: nil) }
      subject { Recipe.next_recipe_of_the_day }
      it { expect(subject).to eq(oldest_never_recipe_of_the_day_recipe) }

      context 'oldest never recipe of the day recipe does not exist' do
        let!(:oldest_never_recipe_of_the_day_recipe) { nil }
        it { expect(subject).to eq(middle_never_recipe_of_the_day_recipe) }

        context 'middle never recipe of the day recipe does not exist' do
          let!(:middle_never_recipe_of_the_day_recipe) { nil }
          it { expect(subject).to eq(newest_never_recipe_of_the_day_recipe) }

          context 'newest never recipe of the day recipe does not exist' do
            let!(:newest_never_recipe_of_the_day_recipe) { nil }
            it { expect(subject).to eq(oldest_previous_recipe_of_the_day_recipe) }

            context 'oldest previous recipe of the day recipe does not exist' do
              let!(:oldest_previous_recipe_of_the_day_recipe) { nil }
              it { expect(subject).to eq(middle_previous_recipe_of_the_day_recipe) }

              context 'middle previous recipe of the day recipe does not exist' do
                let!(:middle_previous_recipe_of_the_day_recipe) { nil }
                it { expect(subject).to eq(newest_previous_recipe_of_the_day_recipe) }

                context 'newest previous recipe of the day recipe does not exist' do
                  let!(:newest_previous_recipe_of_the_day_recipe) { nil }
                  it { expect(subject).to eq(nil) }
                end
              end
            end
          end
        end
      end
    end

    describe '#update_featured_recipes' do
      # COMPLETE THIS
    end

    describe '#set_next_featured_recipe' do
      # COMPLETE THIS
    end

    describe '#next_recipe_to_feature' do
      # COMPLETE THIS
    end
  end

  describe 'currently_featured?' do
    # COMPLETE THIS
  end

  describe 'something' do
    context 'recipe' do
      let(:recipe) { create(:recipe) }
      it 'does something' do
        puts recipe.name
        puts recipe.process
      end
    end

    context 'recipe_with_ingredients' do
      let(:recipe_with_ingredients) { create(:recipe_with_ingredients) }
      it 'does something else' do
        puts recipe_with_ingredients.name
        puts recipe_with_ingredients.ingredients.first.food
        puts recipe_with_ingredients.ingredients.last.food
      end
    end
  end
end
