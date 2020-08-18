class AdminController < ApplicationController
  before_action :set_recipe, except: :index
  after_action :verify_authorized

  def index
    authorize nil, policy_class: AdminPolicy
    @recipes = Recipe.awaiting_approval.order(updated_at: :asc)
  end

  def recipe_approve
    authorize nil, policy_class: AdminPolicy
    @recipe.approve
    redirect_to admin_path
  end

  def recipe_approve_for_feature
    authorize nil, policy_class: AdminPolicy
    @recipe.approve_for_feature
    redirect_to admin_path
  end

  def recipe_approve_for_recipe_of_the_day
    authorize nil, policy_class: AdminPolicy
    @recipe.approve_for_recipe_of_the_day
    redirect_to admin_path
  end

  def recipe_decline
    authorize nil, policy_class: AdminPolicy
    @recipe.decline
    redirect_to admin_path
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end
