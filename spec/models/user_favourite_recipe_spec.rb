require 'rails_helper'

describe UserFavouriteRecipe do
  it { should belong_to :user }
  it { should belong_to :recipe }
end
