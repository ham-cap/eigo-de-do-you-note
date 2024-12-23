class CardsController < ApplicationController
  def index
    @cards = Card.all
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

  private

  def card_params
    params.require(:card).permit(
      :original_text,
      :ja_phrase,
      :en_phrase,
      :memorized_at
    )
  end
end
