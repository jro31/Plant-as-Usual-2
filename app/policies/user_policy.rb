class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  # def toggle_dark_mode
  #   true # Should this be true?
  # end
end
