class DarkMode < ApplicationRecord
  CLASSES = {
    admin_page: 'admin-page',
    btn_docile: 'btn-docile',
    btn_keen: 'btn-keen',
    can_edit_input_display: 'can-edit-input-display',
    custom_navbar: 'custom-navbar',
    hidden_flash_message_container: 'hidden-flash-message-container',
    input_edit: 'input-edit',
    interaction_icons: 'interaction-icons',
    keen_modal: 'keen-modal',
    narrow_recipe_card: 'narrow-recipe-card',
    page_container: 'page-container',
    photo_uploader: 'photo-uploader',
    recipe_content_row: 'recipe-content-row',
    site_logo: 'site-logo',
    site_placeholder: 'site-placeholder',
    text_box: 'text-box',
    welcome_banner: 'welcome-banner',
    wide_recipe_card: 'wide-recipe-card'
  }.freeze

  def self.css_classes
    self::CLASSES.values
  end
end
