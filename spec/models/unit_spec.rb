require 'rails_helper'

describe Unit, type: :model do
  it { should have_many :ingredients }

  describe 'something' do
    context 'unit' do
      let(:unit) { create(:unit) }
      it 'does something' do
        puts unit.name
      end
    end
  end
end
