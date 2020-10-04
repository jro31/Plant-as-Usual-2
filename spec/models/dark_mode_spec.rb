require 'rails_helper'

describe DarkMode do
  describe '::CLASSES' do
    it 'returns a hash of classes' do
      expect(DarkMode::CLASSES).to eq(
        {
          admin_page: 'admin-page',
          alert_docile: 'alert-docile',
          alert_keen: 'alert-keen',
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
        }
      )
    end
  end

  describe '#css_classes' do
    it 'returns an array of classes' do
      expect(DarkMode.css_classes).to eq([
        'admin-page',
        'alert-docile',
        'alert-keen',
        'btn-docile',
        'btn-keen',
        'can-edit-input-display',
        'custom-navbar',
        'hidden-flash-message-container',
        'input-edit',
        'interaction-icons',
        'keen-modal',
        'narrow-recipe-card',
        'page-container',
        'photo-uploader',
        'recipe-content-row',
        'site-logo',
        'site-placeholder',
        'text-box',
        'welcome-banner',
        'wide-recipe-card'
      ])
    end
  end
end
