class CardsController < ApplicationController
  before_action :authenticate
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  def index
    @target = params[:target] || 'all'
    @target = 'all' unless target_allowlist.include?(@target)

    @cards =
      case @target
      when 'memorized'
        current_user.cards.memorized.order(created_at: :desc)
      when 'unmemorized'
        current_user.cards.unmemorized.order(created_at: :desc)
      else
        current_user.cards.order(created_at: :desc)
      end

    @search = @cards.ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?

    @cards = @search.result.page(params[:page])
  end

  def new
    @card = current_user.cards.build
  end

  def create
    @card = Card.generate_a_translated_and_source_text_pair(card_params[:original_text], current_user)
    if @card.save
      flash.now.notice = 'カードを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @card.destroy
    flash.now.notice = 'カードを削除しました'

    respond_to do |format|
      if params[:from_show]
        format.html { redirect_to cards_path, notice: 'カードを削除しました' }
      else
        format.turbo_stream
      end
    end
  end

  def edit
    @from_show = params[:from_show]
  end

  def update
    if @card.update(card_params)
      flash.now.notice = 'カードを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def card_params
    params.require(:card).permit(
      :original_text,
      :ja_phrase,
      :en_phrase
    )
  end

  def target_allowlist
    %w[all memorized unmemorized]
  end

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def authorize_user
    unless @card.user_id == current_user.id
      redirect_to cards_path, alert: 'アクセス権がありません'
    end
  end
end
