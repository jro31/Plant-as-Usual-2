require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }
  describe 'GET #current_user_data' do
    context 'user is signed-in' do
        it '' do
          # Complete this
        end
    end

    context 'user is not signed-in' do
      it 'returns nil' do
        sign_out user
        # Complete this
      end
    end
  end

  describe 'PATCH #toggle_dark_mode' do
    context 'user is signed-in' do
      it '' do
        # Complete this
      end
    end

    context 'user is not signed-in' do
      it '' do
        sign_out user
        # Complete this
      end
    end
  end
end
