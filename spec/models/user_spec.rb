require 'rails_helper'

describe User, type: :model do
  it { should have_many :recipes }

  describe 'destroying a user destroys their recipes' do
    # COMPLETE THIS
  end

  describe 'something' do
    context 'user' do
      let(:user) { create(:user) }
      it 'does something' do
        puts user.first_name
        puts user.last_name
      end
    end
  end
end
