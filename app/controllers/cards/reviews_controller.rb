class Cards::ReviewsController < ApplicationController
  def index
    cards = current_user.cards.unmemorized.order(created_at: :desc)
    if params[:id]
      @card = current_user.cards.find(params[:id])
      @next_card = cards.where('id < ?', @card.id).first
      @previous_card = cards.where('id > ?', @card.id).last
    else
      @card = cards.first
      @next_card = cards.second
    end
  end
end
