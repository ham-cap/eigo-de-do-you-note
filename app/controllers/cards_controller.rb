class CardsController < ApplicationController
  def index
    @target = params[:target]
    @target = 'all' unless target_allowlist.include?(@target)

    @cards =
      case @target
      when 'memorized'
        Card.memorized.order(created_at: :desc)
      when 'unmemorized'
        Card.unmemorized.order(created_at: :desc)
      else
        Card.all.order(created_at: :desc)
      end

    if params[:search_terms]
      target_column = CLD.detect_language(params[:search_terms])[:code] == 'ja' ? 'ja_phrase' : 'en_phrase'
      @cards = @cards.where("#{target_column} ILIKE ?", "%#{params[:search_terms]}%").order(created_at: :desc)
    end
    @cards = @cards.page(params[:page])
    @search_terms = params[:search_terms]
  end

  def new
    @card = Card.new
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
      @card = Card.new(ja_phrase: original_text, en_phrase: translation)
    else
      @card = Card.new(ja_phrase: translation, en_phrase: original_text)
    end

    if @card.save
      respond_to do |format|
        format.html { redirect_to cards_path, notice: 'Card was successfully created.' }
        format.turbo_stream
      end
    else
      render :new
    end
  end

  def show
    @card = Card.find(params[:id])
  end

  def destroy
    @card = Card.find(params[:id])
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_path, notice: '削除しました', status: :see_other }
    end
  end

  def edit
    @card = Card.find(params[:id])
  end

  def update
    @card = Card.find(params[:id])
    if @card.update(card_params)
      respond_to do |format|
        format.html { redirect_to cards_path, notice: 'Card was successfully updated.' }
      end
    else
      render :edit
    end
  end

  def review
    cards = Card.unmemorized.order(created_at: :desc)
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
end
