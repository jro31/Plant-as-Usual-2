class RecipePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def update?
    user_is_owner_or_admin?
  end

  def upload_photo?
    user_is_owner_or_admin?
  end
end
