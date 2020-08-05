class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home # SPEC THIS
  end
end
