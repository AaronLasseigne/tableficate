require 'spec_helper'

describe 'Theme', type: :feature do
  describe 'Column' do
    before(:all) do
      @npw = NobelPrizeWinner.select('nobel_prize_winners.*, nobel_prizes.category, nobel_prizes.year').joins(:nobel_prizes)
    end

    it 'accepts :header_attrs as an option' do
      visit '/themes/column_header_attrs'

      expect(page).to have_xpath('//th[4][@style="background-color: red;"]')
    end

    it 'accepts :cell_attrs as an option' do
      visit '/themes/column_cell_attrs'

      @npw.count.times do |i|
        expect(page).to have_xpath("//tr[#{i+1}]/td[4][@style=\"background-color: red;\"]")
      end
    end

    it 'allows :cell_attrs to take a Proc' do
      visit '/themes/column_cell_attrs_with_proc'

      @npw.each_with_index do |n, i|
        expect(page).to have_xpath("//tr[#{i + 1}]/td[5][@style=\"color: #{n.year > 1950 ? 'green' : 'red'};\"]")
      end
    end

    it 'takes all non-specialized options as attrs on the `col` tag' do
      visit '/themes/column_attrs'

      expect(page.html).to match /<col span="3">\n<col style="background-color: red;">\n<col>/
    end

    it 'only creates `col` tags if needed' do
      visit '/themes/no_column_attrs'

      expect(page).to have_no_xpath('//cols')
    end
  end
end
