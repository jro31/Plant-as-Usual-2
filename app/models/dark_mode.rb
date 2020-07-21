class DarkMode < ApplicationRecord
  CLASSES = {
    custom_navbar: 'custom-navbar',
    narrow_recipe_card: 'narrow-recipe-card',
    page_container: 'page-container',
    text_box: 'text-box',
    welcome_banner: 'welcome-banner',
    wide_recipe_card: 'wide-recipe-card'
  }.freeze

  def self.css_classes
    self::CLASSES.values
  end
end
