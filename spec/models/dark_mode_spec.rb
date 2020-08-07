require 'rails_helper'

describe DarkMode do
  describe '::CLASSES' do
    it 'returns a hash of classes' do
      expect(DarkMode::CLASSES).to eq(
        {
          can_edit_input_display: 'can-edit-input-display',
          custom_navbar: 'custom-navbar',
          input_edit: 'input-edit',
          keen_modal: 'keen-modal',
          narrow_recipe_card: 'narrow-recipe-card',
          page_container: 'page-container',
          photo_uploader: 'photo-uploader',
          recipe_content_row: 'recipe-content-row',
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
        'can-edit-input-display',
        'custom-navbar',
        'input-edit',
        'keen-modal',
        'narrow-recipe-card',
        'page-container',
        'photo-uploader',
        'recipe-content-row',
        'text-box',
        'welcome-banner',
        'wide-recipe-card'
      ])
    end
  end
end
