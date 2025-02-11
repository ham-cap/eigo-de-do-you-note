class CardsController < ApplicationController
  before_action :authenticate
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :edit, :update, :destroy]

  def index
    @target = params[:target]
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
    DeepL.configure do |config|
      config.auth_key = ENV['DEEPL_API_KEY']
      config.host = 'https://api-free.deepl.com'
    end
    original_text = card_params[:original_text]
    inputted_lang = CLD.detect_language(original_text)
    translation = DeepL.translate original_text, nil, inputted_lang[:code] == 'ja' ? 'EN' : 'JA'

    if inputted_lang[:code] == 'ja'
      @card = current_user.cards.build(ja_phrase: original_text, en_phrase: translation)
    else
      @card = current_user.cards.build(ja_phrase: translation, en_phrase: original_text)
    end

    if @card.save
      flash.now.notice = 'Card was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @card = Card.find(params[:id])
  end

  def destroy
    @card = Card.find(params[:id])
    @card.destroy
    flash.now.notice = '削除しました'

    respond_to do |format|
      if params[:from_show]
        format.html { redirect_to cards_path, notice: 'カードを削除しました' }
      else
        format.turbo_stream
      end
    end
  end

  def edit
    @card = Card.find(params[:id])
    @from_show = params[:from_show]
  end

  def update
    if @card.update(card_params)
      flash.now.notice = 'Card was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def review
    cards = current_user.cards.unmemorized.order(created_at: :desc)
    if params[:id]
      @card = Card.find(params[:id])
      @next_card = cards.where('id < ?', @card.id).first
      @previous_card = cards.where('id > ?', @card.id).last
    else
      @card = cards.first
      @next_card = cards.second
    end
  end

  def update_memorized_status
    @card = Card.find(params[:id])
    if @card.memorized_at.nil?
      @card.update(memorized_at: Time.current)
    else
      @card.update(memorized_at: nil)
    end
  end

  private

  def card_params
    params.require(:card).permit(
      :original_text,
      :ja_phrase,
      :en_phrase,
      :memorized_at
    )
  end

  def target_allowlist
    target_allowlist = %w[all memorized unmemorized]
  end

  def set_card
    @card = Card.find(params[:id])
  end

  def authorize_user
    unless @card.user_id == current_user.id
      redirect_to cards_path, alert: 'アクセス権がありません'
    end
  end
end
