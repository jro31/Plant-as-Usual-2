require 'rails_helper'

describe ApplicationHelper do
  helper do
    def user_signed_in?
      current_user.present?
    end
  end
  let!(:current_user) { create(:user, dark_mode: true) }

  describe '#display_mode(component)' do
    context 'user is not signed-in' do
      let!(:current_user) { nil }
      it 'returns light-mode' do
        expect(display_mode('navbar')).to eq('navbar-light-mode')
      end
    end

    context 'current_user.dark_mode is true' do
      it 'returns dark-mode' do
        expect(display_mode('navbar')).to eq('navbar-dark-mode')
      end
    end

    context 'current_user.dark_mode is false' do
      let!(:current_user) { create(:user, dark_mode: false) }
      it 'returns light-mode' do
        expect(display_mode('navbar')).to eq('navbar-light-mode')
      end
    end
  end
end
