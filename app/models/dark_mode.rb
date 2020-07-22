class DarkMode < ApplicationRecord
  CLASSES = {
    can_edit_input_display: 'can-edit-input-display',
    custom_navbar: 'custom-navbar',
    keen_modal: 'keen-modal',
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
