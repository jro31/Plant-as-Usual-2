require 'rails_helper'

describe AccountsController, type: :controller do
  let(:user) { create(:user, username: 'aloy', email: 'aloy@ofthenora.tribe', password: 'latrineresh', twitter_handle: 'allmotherwhisperer', instagram_handle: 'outkast_pix', website_url: 'https://www.aloysworld.com/') }
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
            expect(flash[:alert]).to eq('Fail. Username cannot contain spaces.')
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
            expect(flash[:alert]).to eq('Fail. Email is invalid.')
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end
      end
    end

    describe 'twitter handle' do
      let(:params) { { user: { twitter_handle: new_twitter_handle } } }
      context 'user is signed-in' do
        context 'new twitter handle is valid' do
          let(:new_twitter_handle) { 'watcher_hunter' }
          it 'updates the twitter handle' do
            expect(user.twitter_handle).to eq('allmotherwhisperer')
            patch :update_user, params: params
            expect(user.reload.twitter_handle).to eq('watcher_hunter')
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end

        context 'new twitter handle is not valid' do
          let(:new_twitter_handle) { '@fuck deathbringers' }
          it 'does not update the twitter handle' do
            expect(user.twitter_handle).to eq('allmotherwhisperer')
            patch :update_user, params: params
            expect(user.reload.twitter_handle).to eq('allmotherwhisperer')
          end

          it 'displays a flash message' do
            patch :update_user, params: params
            expect(flash[:alert]).to eq('Fail. Twitter handle cannot contain spaces.')
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end
      end
    end

    describe 'instagram handle' do
      let(:params) { { user: { instagram_handle: new_instagram_handle } } }
      context 'user is signed-in' do
        context 'new instagram handle is valid' do
          let(:new_instagram_handle) { 'hades_who' }
          it 'updates the instagram handle' do
            expect(user.instagram_handle).to eq('outkast_pix')
            patch :update_user, params: params
            expect(user.reload.instagram_handle).to eq('hades_who')
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end

        context 'new instagram handle is not valid' do
          let(:new_instagram_handle) { 'faro is a dick' }
          it 'does not update the instagram handle' do
            expect(user.instagram_handle).to eq('outkast_pix')
            patch :update_user, params: params
            expect(user.reload.instagram_handle).to eq('outkast_pix')
          end

          it 'displays a flash message' do
            patch :update_user, params: params
            expect(flash[:alert]).to eq('Fail. Instagram handle cannot contain spaces.')
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end
      end
    end

    describe 'website url' do
      let(:params) { { user: { website_url: new_website_url } } }
      context 'user is signed-in' do
        context 'new website url is valid' do
          let(:new_website_url) { 'http://www.proving-tips.com/' }
          it 'updates the website url' do
            expect(user.website_url).to eq('https://www.aloysworld.com/')
            patch :update_user, params: params
            expect(user.reload.website_url).to eq('http://www.proving-tips.com/')
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end

        context 'new website url is not valid' do
          let(:new_website_url) { 'www.seeker diaries.com' }
          it 'does not update the website url' do
            expect(user.website_url).to eq('https://www.aloysworld.com/')
            patch :update_user, params: params
            expect(user.reload.website_url).to eq('https://www.aloysworld.com/')
          end

          it 'displays a flash message' do
            patch :update_user, params: params
            expect(flash[:alert]).to eq('Fail. Website url cannot contain spaces.')
          end

          it 'redirects to the account page' do
            patch :update_user, params: params
            expect(response).to redirect_to account_path
          end
        end
      end
    end
  end

  describe 'PATCH #update_password' do
    let(:params) { { user: { current_password: current_password, password: new_password, password_confirmation: new_password_confirmation } } }
    let(:current_password) { 'latrineresh' }
    let(:new_password) { 'meridian4life' }
    let(:new_password_confirmation) { new_password }
    context 'user is signed-in' do
      context 'current password is correct' do
        context 'password and password confirmation match' do
          context 'password is valid' do
            it 'updates the password' do
              old_encrypted_password = user.encrypted_password
              patch :update_password, params: params
              expect(user.reload.encrypted_password).not_to eq(old_encrypted_password)
            end

            it 'displays a flash message' do
              patch :update_password, params: params
              expect(flash[:alert]).to eq('Success')
            end

            it 'redirects to the account page' do
              patch :update_password, params: params
              expect(response).to redirect_to account_path
            end
          end

          context 'password is not valid' do
            let(:new_password) { 'sobek' }
            it 'does not update the password' do
              old_encrypted_password = user.encrypted_password
              patch :update_password, params: params
              expect(user.reload.encrypted_password).to eq(old_encrypted_password)
            end

            it 'displays a flash message' do
              patch :update_password, params: params
              expect(flash[:alert]).to eq('Fail. Password is too short (minimum is 8 characters).')
            end

            it 'redirects to the account page' do
              patch :update_password, params: params
              expect(response).to redirect_to account_path
            end
          end
        end

        context 'password and password confirmation do not match' do
          let(:new_password_confirmation) { 'meridian5life' }
          it 'does not update the password' do
            old_encrypted_password = user.encrypted_password
            patch :update_password, params: params
            expect(user.reload.encrypted_password).to eq(old_encrypted_password)
          end

          it 'displays a flash message' do
            patch :update_password, params: params
            expect(flash[:alert]).to eq("Fail. Password confirmation doesn't match Password.")
          end

          it 'redirects to the account page' do
            patch :update_password, params: params
            expect(response).to redirect_to account_path
          end
        end
      end

      context 'current password is incorrect' do
        let(:current_password) { 'latrinerash' }
        it 'does not update the password' do
          old_encrypted_password = user.encrypted_password
          patch :update_password, params: params
          expect(user.reload.encrypted_password).to eq(old_encrypted_password)
        end

        it 'displays a flash message' do
          patch :update_password, params: params
          expect(flash[:alert]).to eq("Fail. Current password is invalid.")
        end

        it 'redirects to the account page' do
          patch :update_password, params: params
          expect(response).to redirect_to account_path
        end
      end
    end

    context 'user is not signed-in' do
      it 'redirects to the sign-in page' do
        sign_out user
        patch :update_password, params: params
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
