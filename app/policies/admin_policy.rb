class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user_is_admin?
  end

  def recipe_approve?
    user_is_admin?
  end

  def recipe_approve_for_feature?
    user_is_admin?
  end

  def recipe_approve_for_recipe_of_the_day?
    user_is_admin?
  end

  def recipe_decline?
    user_is_admin?
  end

  private

  def user_is_admin?
    user&.admin
  end
end
