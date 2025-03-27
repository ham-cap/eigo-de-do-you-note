class ReviewsController < ApplicationController
  def show
    cards = current_user.cards.unmemorized.order(created_at: :desc)

    return @card = nil unless cards.present?

    if params[:id] == 'first'
      @card = cards.first
      @next_card = cards.where('id < ?', @card.id).first
    else
      @card = cards.find(params[:id])
      @next_card = cards.where('id < ?', @card.id).first
      @previous_card = cards.where('id > ?', @card.id).last
    end
  end
end
