require 'rails_helper'

describe AccountsController, type: :controller do
  let(:user) { create(:user, username: 'aloy', email: 'aloy@ofthenora.tribe') }
  before { sign_in user }

  describe 'GET #show' do
    context 'user is signed-in' do
      it 'returns http success' do
        get :show
        expect(response).to be_successful
      end
    end

    context 'user is not signed-in' do
      it 'redirects to the sign-in page' do
        sign_out user
        get :show
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update_user' do
    describe 'username' do
      let(:params) { { user: { username: new_username } } }
      context 'user is signed-in' do
        context 'new username is valid' do
          let(:new_username) { 'i_survived' }
          it 'updates the username' do
            expect(user.username).to eq('aloy')
            patch :update_user, params: params
            expect(user.reload.username).to eq('i_survived')
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end

        context 'new username is not valid' do
          let(:new_username) { 'Rost forever' }
          it 'does not update the username' do
            expect(user.username).to eq('aloy')
            patch :update_user, params: params
            expect(user.reload.username).to eq('aloy')
          end

          it 'displays a flash message' do
            patch :update_user, params: params
            expect(flash[:alert]).to eq 'Fail. Username cannot contain spaces.'
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end
      end

      context 'user is not signed-in' do
        context 'new username is valid' do
          let(:new_username) { 'i_survived' }
          it 'redirects to the sign-in page' do
            sign_out user
            patch :update_user, params: params
            expect(response).to redirect_to new_user_session_path
          end
        end
      end
    end

    describe 'email' do
      let(:params) { { user: { email: new_email } } }
      context 'user is signed-in' do
        context 'new email is valid' do
          let(:new_email) { 'aloy@despitethenora.tribe' }
          it 'updates the email address' do
            expect(user.email).to eq('aloy@ofthenora.tribe')
            patch :update_user, params: params
            expect(user.reload.email).to eq('aloy@despitethenora.tribe')
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end

        context 'new email is not valid' do
          let(:new_email) { 'rost of the nora.tribe' }
          it 'does not update the email address' do
            expect(user.email).to eq('aloy@ofthenora.tribe')
            patch :update_user, params: params
            expect(user.reload.email).to eq('aloy@ofthenora.tribe')
          end

          it 'displays a flash message' do
            patch :update_user, params: params
            expect(flash[:alert]).to eq 'Fail. Email is invalid.'
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end
      end
    end

    describe 'twitter handle' do
      # COMPLETE THIS
    end

    describe 'instagram handle' do
      # COMPLETE THIS
    end

    describe 'website url' do
      # COMPLETE THIS
    end
  end
end
