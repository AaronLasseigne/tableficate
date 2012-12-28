require 'spec_helper'

describe 'Theme', type: :feature do
  describe 'Empty' do
    it 'displays text when the table has no data' do
      visit '/themes/empty_with_no_data'

      expect(page).to have_xpath('//td[1][text()="There is no data."]')
    end

    it 'does not display text when the table has data' do
      visit '/themes/empty_with_data'

      expect(page).to have_no_xpath('//td[1][text()="There is no data."]')
    end
  end
end
