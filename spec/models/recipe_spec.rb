require 'rails_helper'

describe Recipe do
  it { should belong_to :user }
  it { should have_many :ingredients }

  let(:recipe) { create(:recipe) }

  describe 'NUMBER_OF_RECIPES_OF_THE_DAY' do
    it { expect(Recipe::NUMBER_OF_RECIPES_OF_THE_DAY).to eq(1) }
  end

  describe 'NUMBER_OF_FEATURED_RECIPES' do
    it { expect(Recipe::NUMBER_OF_FEATURED_RECIPES).to eq(12) }
  end

  describe 'destroying a recipe destroys ingredients' do
    let!(:ingredient) { create(:ingredient, id: 999, recipe: recipe) }
    it 'destroys the ingredient' do
      expect(Ingredient.find(999)).to eq(ingredient)
      recipe.destroy
      expect { Ingredient.find(999) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'validations' do
    describe '#validate_number_of_featured_recipes' do
      before do
        create_list(:recipe, currently_featured_count, state: :currently_featured)
        create_list(:recipe, 6, state: :recipe_of_the_day_as_currently_featured)
      end
      subject { create(:recipe, state: :approved_for_feature) }
      context 'will_save_change_to_state? is true' do
        context 'subject will update to currently_featured' do
          before { subject.state = 'currently_featured' }
          context 'there are already twelve or more currently featured recipes' do
            let(:currently_featured_count) { 6 }
            it { expect(subject).not_to be_valid }
          end

          context 'there are less than twelve currently featured recipes' do
            let(:currently_featured_count) { 5 }
            it { expect(subject).to be_valid }
          end
        end

        context 'subject will update to recipe_of_the_day_as_currently_featured' do
          before { subject.state = 'recipe_of_the_day_as_currently_featured' }
          context 'there are already twelve or more currently featured recipes' do
            let(:currently_featured_count) { 6 }
            it { expect(subject).not_to be_valid }
          end

          context 'there are less than twelve currently featured recipes' do
            let(:currently_featured_count) { 5 }
            it { expect(subject).to be_valid }
          end
        end

        context 'subject will update to something else' do
          before { subject.state = 'current_recipe_of_the_day' }
          context 'there are already twelve or more currently featured recipes' do
            let(:currently_featured_count) { 6 }
            it { expect(subject).to be_valid }
          end
        end
      end

      context 'will_save_change_to_state? is false' do
        before { subject.name = 'Big Papa' }
        context 'there are already twelve or more currently featured recipes' do
          let(:currently_featured_count) { 6 }
          it { expect(subject).to be_valid }
        end
      end
    end

    describe '#validate_number_of_recipes_of_the_day' do
      subject { create(:recipe, state: :approved_for_recipe_of_the_day) }
      context 'will_save_change_to_state? is true' do
        context 'subject will update to current_recipe_of_the_day' do
          before { subject.state = 'current_recipe_of_the_day' }
          context 'there is an existing recipe of the day' do
            let!(:current_recipe_of_the_day_recipe) { create(:recipe, state: :current_recipe_of_the_day) }
            it { expect(subject).not_to be_valid }
          end

          context 'there is not an existing recipe of the day' do
            it { expect(subject).to be_valid }
          end
        end

        context 'subject will update to something else' do
          before { subject.state = 'recipe_of_the_day_as_currently_featured' }
          context 'there is an existing recipe of the day' do
            let!(:current_recipe_of_the_day_recipe) { create(:recipe, state: :current_recipe_of_the_day) }
            it { expect(subject).to be_valid }
          end
        end
      end

      context 'will_save_change_to_state? is false' do
        before { subject.name = 'Big Papa' }
        context 'there is an existing recipe of the day' do
          let!(:current_recipe_of_the_day_recipe) { create(:recipe, state: :current_recipe_of_the_day) }
          it { expect(subject).to be_valid }
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'after_save' do
      describe '#state_changed_methods' do
        subject { create(:recipe, name: 'Vegan burger', state: :incomplete) }
        context 'state is changed by event' do
          it 'calls state_changed_methods' do
            expect(subject).to receive(:state_changed_methods).once
            subject.complete
          end
        end

        context 'state is changed manually' do
          it 'calls state_changed_methods' do
            expect(subject).to receive(:state_changed_methods).once
            subject.update(state: :approved_for_recipe_of_the_day)
          end
        end

        context 'state is not changed' do
          it 'does not call state_changed_methods' do
            expect(subject).to receive(:state_changed_methods).never
            subject.update(name: 'Vegan burgim')
          end
        end

        describe '#set_next_featured_recipe' do
          subject { create(:recipe, name: 'Bean Soup', state: :currently_featured) }
          context 'state is changed from currently_featured' do
            context 'state is changed by event' do
              it 'calls the set_next_featured_recipe instance method' do
                expect(subject).to receive(:set_next_featured_recipe).once
                subject.revert_from_highlighted
              end

              it 'calls the set_next_featured_recipe class method' do
                expect(Recipe).to receive(:set_next_featured_recipe).once
                subject.revert_from_highlighted
              end
            end

            context 'state is changed manually' do
              it 'calls the set_next_featured_recipe instance method' do
                expect(subject).to receive(:set_next_featured_recipe).once
                subject.update(state: :awaiting_approval)
              end

              it 'calls the set_next_featured_recipe class method' do
                expect(Recipe).to receive(:set_next_featured_recipe).once
                subject.update(state: :awaiting_approval)
              end
            end
          end

          context 'state is changed from recipe_of_the_day_as_currently_featured' do
            subject { create(:recipe, state: :recipe_of_the_day_as_currently_featured) }
            context 'state is changed by event' do
              it 'calls the set_next_featured_recipe instance method' do
                expect(subject).to receive(:set_next_featured_recipe).once
                subject.revert_from_highlighted
              end

              it 'calls the set_next_featured_recipe class method' do
                expect(Recipe).to receive(:set_next_featured_recipe).once
                subject.revert_from_highlighted
              end
            end

            context 'state is changed manually' do
              it 'calls the set_next_featured_recipe instance method' do
                expect(subject).to receive(:set_next_featured_recipe).once
                subject.update(state: :currently_featured)
              end

              it 'calls the set_next_featured_recipe class method' do
                expect(Recipe).to receive(:set_next_featured_recipe).once
                subject.update(state: :currently_featured)
              end
            end
          end

          context 'state is changed from something else' do
            subject { create(:recipe, state: :current_recipe_of_the_day) }
            it 'calls the set_next_featured_recipe instance method' do
              expect(subject).to receive(:set_next_featured_recipe).once
              subject.update(state: :awaiting_approval)
            end

            it 'does not call the set_next_featured_recipe class method' do
              expect(Recipe).to receive(:set_next_featured_recipe).never
              subject.update(state: :awaiting_approval)
            end
          end

          context 'state is not changed' do
            it 'does not call the set_next_featured_recipe instance method' do
              expect(subject).to receive(:set_next_featured_recipe).never
              subject.update(name: 'Former soup')
            end

            it 'does not call the set_next_featured_recipe class method' do
              expect(Recipe).to receive(:set_next_featured_recipe).never
              subject.update(name: 'Former soup')
            end
          end
        end

        describe '#set_next_recipe_of_the_day' do
          subject { create(:recipe, name: 'Potatoes', state: :current_recipe_of_the_day) }
          context 'state is changed from current_recipe_of_the_day' do
            context 'state is changed by event' do
              it 'calls the set_next_recipe_of_the_day instance method' do
                expect(subject).to receive(:set_next_recipe_of_the_day).once
                subject.revert_from_highlighted
              end

              it 'calls the set_next_recipe_of_the_day class method' do
                expect(Recipe).to receive(:set_next_recipe_of_the_day).once
                subject.revert_from_highlighted
              end
            end

            context 'state is changed manually' do
              it 'calls the set_next_recipe_of_the_day instance method' do
                expect(subject).to receive(:set_next_recipe_of_the_day).once
                subject.update(state: :awaiting_approval)
              end

              it 'calls the set_next_recipe_of_the_day class method' do
                expect(Recipe).to receive(:set_next_recipe_of_the_day).once
                subject.update(state: :awaiting_approval)
              end
            end
          end

          context 'state is changed from something else' do
            subject { create(:recipe, state: :recipe_of_the_day_as_currently_featured) }
            it 'calls the set_next_recipe_of_the_day instance method' do
              expect(subject).to receive(:set_next_recipe_of_the_day).once
              subject.update(state: :awaiting_approval)
            end

            it 'does not call the set_next_recipe_of_the_day class method' do
              expect(Recipe).to receive(:set_next_recipe_of_the_day).never
              subject.update(state: :awaiting_approval)
            end
          end

          context 'state is not changed' do
            it 'does not call the set_next_recipe_of_the_day instance method' do
              expect(subject).to receive(:set_next_recipe_of_the_day).never
              subject.update(name: 'Potafingers')
            end

            it 'does not call the set_next_recipe_of_the_day class method' do
              expect(Recipe).to receive(:set_next_recipe_of_the_day).never
              subject.update(name: 'Potafingers')
            end
          end
        end

        describe '#send_awaiting_approval_slack_message' do
          let(:user) { create(:user, username: 'big_jesus') }
          context 'complete event' do
            subject { create(:recipe, user: user, name: 'Vegan Pizza', state: :incomplete) }
            it 'calls send_awaiting_approval_slack_message on the recipe' do
              expect(subject).to receive(:send_awaiting_approval_slack_message).once
              subject.complete
            end

            it 'calls SendSlackMessageJob with the correct arguments' do
              expect(SendSlackMessageJob).to receive(:perform_later).with("'Vegan Pizza' by big_jesus is awaiting approval https://www.plantasusual.com/admin", nature: 'surprise').once
              subject.complete
            end
          end

          context 'manually updated' do
            subject { create(:recipe, user: user, name: 'Rasta Pasta', state: :current_recipe_of_the_day) }
            context 'state is updated to awaiting_approval' do
              it 'calls send_awaiting_approval_slack_message on the recipe' do
                expect(subject).to receive(:send_awaiting_approval_slack_message).once
                subject.update(state: :awaiting_approval)
              end

              it 'calls SendSlackMessageJob with the correct arguments' do
                expect(SendSlackMessageJob).to receive(:perform_later).with("'Rasta Pasta' by big_jesus is awaiting approval https://www.plantasusual.com/admin", nature: 'surprise').once
                subject.update(state: :awaiting_approval)
              end
            end

            context 'state is updated to something else' do
              it 'calls send_awaiting_approval_slack_message on the recipe' do
                expect(subject).to receive(:send_awaiting_approval_slack_message).once
                subject.update(state: :incomplete)
              end

              it 'does not call SendSlackMessageJob' do
                expect(SendSlackMessageJob).to receive(:perform_later).never
                subject.update(state: :incomplete)
              end
            end

            context 'state is not updated' do
              it 'does not call send_awaiting_approval_slack_message on the recipe' do
                expect(subject).to receive(:send_awaiting_approval_slack_message).never
                subject.update(name: 'Yeti Spaghetti')
              end
            end
          end
        end

        describe '#update_state_updated_at' do
          before { Timecop.freeze }
          after { Timecop.return }
          subject { create(:recipe, state: :incomplete) }
          before { subject.update(state_updated_at: 1.day.ago) }
          context 'state is updated' do
            it 'sets state_updated_at' do
              expect(subject.state_updated_at).to eq(1.day.ago)
              subject.complete
              expect(subject.state_updated_at).to eq(Time.now)
            end
          end

          context 'state is not updated' do
            it 'does not set state_updated_at' do
              expect(subject.state_updated_at).to eq(1.day.ago)
              subject.update(name: 'Big Pizza')
              expect(subject.state_updated_at).to eq(1.day.ago)
            end
          end
        end
      end
    end
  end

  describe 'scopes' do
    let!(:incomplete_recipe) { create(:recipe, state: :incomplete) }
    let!(:awaiting_approval_recipe) { create(:recipe, state: :awaiting_approval) }
    let!(:approved_recipe) { create(:recipe, state: :approved) }
    let!(:approved_for_feature_recipe) { create(:recipe, state: :approved_for_feature) }
    let!(:approved_for_recipe_of_the_day_recipe) { create(:recipe, state: :approved_for_recipe_of_the_day) }
    let!(:currently_featured_recipe) { create(:recipe, state: :currently_featured, last_featured_at: 2.hours.ago) }
    let!(:recipe_of_the_day_as_currently_featured_recipe) { create(:recipe, state: :recipe_of_the_day_as_currently_featured, last_featured_at: 1.hours.ago) }
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

    describe '.current_recipes_of_the_day' do
      subject { Recipe.current_recipes_of_the_day }
      it { expect(subject).to eq([current_recipe_of_the_day_recipe]) }
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

    describe '.available_to_show' do
      subject { Recipe.available_to_show }
      it { expect(subject).to include(awaiting_approval_recipe, approved_recipe, approved_for_feature_recipe, approved_for_recipe_of_the_day_recipe, currently_featured_recipe, recipe_of_the_day_as_currently_featured_recipe, current_recipe_of_the_day_recipe) }
      it { expect(subject).not_to include(incomplete_recipe, declined_recipe, hidden_recipe) }
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
      before { all_recipes.each { |recipe| recipe&.send(event) } }
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
        it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('approved_for_recipe_of_the_day') }
        context 'no current recipe of the day exists' do
          let(:current_recipe_of_the_day_recipe) { nil }
          it { expect(approved_for_recipe_of_the_day_recipe.state).to eq('current_recipe_of_the_day') }
        end
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
  end

  describe 'class methods' do
    let(:recipe) { create(:recipe) }
    describe '#update_highlighted_recipes' do
      subject { Recipe.update_highlighted_recipes }
      it 'calls update_recipes_of_the_day' do
        expect(Recipe).to receive(:update_recipes_of_the_day).once.and_call_original
        subject
      end

      it 'calls update_featured_recipes' do
        expect(Recipe).to receive(:update_featured_recipes).once.and_call_original
        subject
      end
    end

    describe '#update_recipes_of_the_day' do
      let!(:current_recipe_of_the_day) { create(:recipe, state: :current_recipe_of_the_day, last_recipe_of_the_day_at: 1.day.ago) }
      let!(:next_recipe_of_the_day) { create(:recipe, state: :approved_for_recipe_of_the_day, last_recipe_of_the_day_at: nil) }
      subject { Recipe.update_recipes_of_the_day }
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

      context 'there is no existing recipe of the day' do
        let!(:current_recipe_of_the_day) { create(:recipe, state: :approved_for_recipe_of_the_day, last_recipe_of_the_day_at: 1.day.ago) }
        it 'sets next_recipe_of_the_day as recipe of the day' do
          subject
          expect(next_recipe_of_the_day.reload.state).to eq('current_recipe_of_the_day')
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
            expect(next_recipe_of_the_day.reload.last_recipe_of_the_day_at.round).to eq(Time.now.round)
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
      before { Timecop.freeze }
      after { Timecop.return }
      subject { Recipe.update_featured_recipes }
      let!(:currently_featured_recipe_1) { create(:recipe, id: 1, state: :currently_featured, last_featured_at: 23.hours.ago) }
      let!(:currently_featured_recipe_2) { create(:recipe, id: 2, state: :currently_featured, last_featured_at: 23.hours.ago - 1.minute) }
      let!(:currently_featured_recipe_3) { create(:recipe, id: 3, state: :currently_featured, last_featured_at: 23.hours.ago + 1.minute) }
      let!(:currently_featured_recipe_4) { create(:recipe, id: 4, state: :currently_featured, last_featured_at: 23.hours.ago - 3.minutes) }
      let!(:recipe_of_the_day_as_currently_featured_recipe_1) { create(:recipe, id: 5, state: :recipe_of_the_day_as_currently_featured, last_featured_at: 23.hours.ago) }
      let!(:recipe_of_the_day_as_currently_featured_recipe_2) { create(:recipe, id: 6, state: :recipe_of_the_day_as_currently_featured, last_featured_at: 23.hours.ago - 2.minutes) }
      let!(:recipe_of_the_day_as_currently_featured_recipe_3) { create(:recipe, id: 7, state: :recipe_of_the_day_as_currently_featured, last_featured_at: 23.hours.ago + 2.minutes) }
      let!(:recipe_of_the_day_as_currently_featured_recipe_4) { create(:recipe, id: 8, state: :recipe_of_the_day_as_currently_featured, last_featured_at: 23.hours.ago - 4.minutes) }
      let!(:approved_for_feature_recipe_1) { create(:recipe, id: 9, state: :approved_for_feature, last_featured_at: nil) }
      let!(:approved_for_feature_recipe_2) { create(:recipe, id: 10, state: :approved_for_feature, last_featured_at: 1.month.ago) }
      let!(:approved_for_feature_recipe_3) { create(:recipe, id: 11, state: :approved_for_feature, last_featured_at: 1.week.ago) }
      let!(:approved_for_feature_recipe_4) { create(:recipe, id: 12, state: :approved_for_feature, last_featured_at: 14.days.ago) }
      let!(:approved_for_recipe_of_the_day_recipe_1) { create(:recipe, id: 13, state: :approved_for_recipe_of_the_day, last_featured_at: nil) }
      let!(:approved_for_recipe_of_the_day_recipe_2) { create(:recipe, id: 14, state: :approved_for_recipe_of_the_day, last_featured_at: 1.month.ago) }
      let!(:approved_for_recipe_of_the_day_recipe_3) { create(:recipe, id: 15, state: :approved_for_recipe_of_the_day, last_featured_at: 1.week.ago) }
      let!(:approved_for_recipe_of_the_day_recipe_4) { create(:recipe, id: 16, state: :approved_for_recipe_of_the_day, last_featured_at: 14.days.ago) }
      it 'calls set_next_featured_recipe 10 times' do
        expect(Recipe).to receive(:set_next_featured_recipe).exactly(10).times.and_call_original
        subject
      end

      it 'features a total of twelve recipes' do
        subject
        expect(Recipe.currently_featured.count).to eq(12)
      end

      it 'features all of the approved for feature recipes' do
        subject
        expect(approved_for_feature_recipe_1.reload.state).to eq('currently_featured')
        expect(approved_for_feature_recipe_2.reload.state).to eq('currently_featured')
        expect(approved_for_feature_recipe_3.reload.state).to eq('currently_featured')
        expect(approved_for_feature_recipe_4.reload.state).to eq('currently_featured')
        expect(approved_for_recipe_of_the_day_recipe_1.reload.state).to eq('recipe_of_the_day_as_currently_featured')
        expect(approved_for_recipe_of_the_day_recipe_2.reload.state).to eq('recipe_of_the_day_as_currently_featured')
        expect(approved_for_recipe_of_the_day_recipe_3.reload.state).to eq('recipe_of_the_day_as_currently_featured')
        expect(approved_for_recipe_of_the_day_recipe_4.reload.state).to eq('recipe_of_the_day_as_currently_featured')
      end

      it 'continues to feature the recipes that were featured less than 23 hours ago' do
        subject
        expect(currently_featured_recipe_3.reload.state).to eq('currently_featured')
        expect(recipe_of_the_day_as_currently_featured_recipe_3.reload.state).to eq('recipe_of_the_day_as_currently_featured')
      end

      it 're-features the remaining currently featured recipes that were featured the longest time ago' do
        subject
        expect(currently_featured_recipe_4.reload.state).to eq('currently_featured')
        expect(recipe_of_the_day_as_currently_featured_recipe_4.reload.state).to eq('recipe_of_the_day_as_currently_featured')
      end

      it 'does not re-feature the remanining currently featured receipes that were featured most recently' do
        subject
        expect(currently_featured_recipe_2.reload.state).to eq('approved_for_feature')
        expect(recipe_of_the_day_as_currently_featured_recipe_2.reload.state).to eq('approved_for_recipe_of_the_day')
      end
    end

    describe '#set_next_featured_recipe' do
      before { Timecop.freeze }
      after { Timecop.return }
      subject { Recipe.set_next_featured_recipe }
      let!(:approved_for_feature_recipe) { create(:recipe, state: :approved_for_feature) }
      context 'number of currently featured recipes is greater/equal to NUMBER_OF_FEATURED_RECIPES' do
        before do
          create_list(:recipe, 6, state: :currently_featured)
          create_list(:recipe, 6, state: :recipe_of_the_day_as_currently_featured)
        end
        it { expect(Recipe.currently_featured.count).to eq(12) }

        it 'does not call next_recipe_to_feature' do
          expect(Recipe).to receive(:next_recipe_to_feature).never
          subject
        end

        it 'does not update the next recipe to feature' do
          subject
          expect(approved_for_feature_recipe.reload.state).to eq('approved_for_feature')
        end
      end

      context 'number of currently featured recipes is less than NUMBER_OF_FEATURED_RECIPES' do
        before do
          create_list(:recipe, 5, state: :currently_featured)
          create_list(:recipe, 4, state: :recipe_of_the_day_as_currently_featured)
        end
        it { expect(Recipe.currently_featured.count).to eq(9) }

        context 'there is a next_recipe_to_feature' do
          it 'calls next_recipe_to_feature' do
            expect(Recipe).to receive(:next_recipe_to_feature).once.and_call_original
            subject
          end

          it 'calls feature' do
            expect_any_instance_of(Recipe).to receive(:feature).once
            subject
          end

          it 'updates the state of the next recipe to feature' do
            subject
            expect(approved_for_feature_recipe.reload.state).to eq('currently_featured')
          end

          it 'sets last_featured_at of the next recipe to feature' do
            subject
            expect(approved_for_feature_recipe.reload.last_featured_at.round).to eq(Time.now.round)
          end
        end

        context 'there is not a next_recipe_to_feature' do
          let!(:approved_for_feature_recipe) { nil }
          it 'calls next_recipe_to_feature' do
            expect(Recipe).to receive(:next_recipe_to_feature).once.and_call_original
            subject
          end

          it 'does not call feature' do
            expect_any_instance_of(Recipe).to receive(:feature).never
            subject
          end
        end
      end
    end

    describe '#next_recipe_to_feature' do
      let!(:approved_recipe) { create(:recipe, state: :approved, created_at: 1.second.ago) }
      subject { Recipe.next_recipe_to_feature }
      context 'no recipes are approved for feature' do
        it 'returns nil' do
          expect(subject).to eq(nil)
        end
      end

      context 'recipes approved for feature exist' do
        let!(:approved_for_recipe_of_the_day_recipe_1) { create(:recipe, state: :approved_for_recipe_of_the_day, last_featured_at: 1.month.ago) }
        let!(:approved_for_feature_recipe_1) { create(:recipe, state: :approved_for_feature, last_featured_at: 1.year.ago) }
        let!(:approved_for_feature_recipe_2) { create(:recipe, state: :approved_for_feature, last_featured_at: 1.week.ago) }
        context 'never featured recipes exist' do
          let!(:approved_for_recipe_of_the_day_recipe_2) { create(:recipe, state: :approved_for_recipe_of_the_day, created_at: 1.hour.ago, last_featured_at: nil) }
          let!(:approved_for_recipe_of_the_day_recipe_3) { create(:recipe, state: :approved_for_recipe_of_the_day, created_at: 1.week.ago, last_featured_at: nil) }
          let!(:approved_for_feature_recipe_3) { create(:recipe, state: :approved_for_feature, created_at: 1.day.ago, last_featured_at: nil) }
          it 'returns the never featured recipe created the longest ago' do
            expect(subject).to eq(approved_for_recipe_of_the_day_recipe_3)
          end
        end

        context 'never featured recipes do not exist' do
          it 'returns the recipe last featured the longest ago' do
            expect(subject).to eq(approved_for_feature_recipe_1)
          end
        end
      end
    end
  end

  describe 'instance methods' do
    describe '#awaiting_approval?' do
      context 'state is awaiting_approval' do
        before { recipe.update(state: 'awaiting_approval') }
        it { expect(recipe.awaiting_approval?).to eq(true) }
      end

      context 'state is not awaiting_approval' do
        before { recipe.update(state: 'incomplete') }
        it { expect(recipe.awaiting_approval?).to eq(false) }
      end
    end

    describe '#has_photo?' do
      let(:test_photo) { fixture_file_upload(Rails.root.join('public', 'test-photo.jpg'), 'image/jpg') }
      context 'recipe has a photo' do
        before { recipe.update(photo: test_photo) }
        it { expect(recipe.has_photo?).to eq(true) }
      end

      context 'recipe does not have a photo' do
        it { expect(recipe.has_photo?).to eq(false) }
      end
    end
  end
end
