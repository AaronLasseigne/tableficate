require 'spec_helper'

describe 'Theme', type: :feature do
  describe 'Caption' do
    it 'displays a caption if one is specified' do
      visit '/themes/caption'

      expect(page).to have_xpath('//caption[text()="Nobel Prize Winners"]')
    end

    it 'displays no caption if no caption is specified' do
      visit '/themes/no_caption'

      expect(page).to have_no_xpath('//caption')
    end
  end
end
