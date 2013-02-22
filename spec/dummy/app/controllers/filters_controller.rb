class FiltersController < ApplicationController
  before_filter :get_npw

  def get_npw
    @npw = NobelPrizeWinner.select('nobel_prize_winners.*, nobel_prizes.*').joins(:nobel_prizes).tableficate(params)
  end
end
