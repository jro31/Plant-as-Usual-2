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
end
