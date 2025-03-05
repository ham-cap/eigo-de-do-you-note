class Cards::MemorizedButtonsController < ApplicationController
  def update
    @card = current_user.cards.find(params[:id])
    if @card.memorized_at.nil?
      @card.update(memorized_at: Time.current)
    else
      @card.update(memorized_at: nil)
    end
  end
end
