require 'rails_helper'

RSpec.describe "Cards", type: :system do
  before do
    @cards = []
    3.times do
      @cards << FactoryBot.create(:card)
    end
  end

  it 'display a list of cards' do
    visit cards_path
    expect(page).to have_content "Cards#index"
    expect(page).to have_content "こんにちは 10"
    expect(page).to have_content "こんにちは 11"
    expect(page).to have_content "こんにちは 12"
    expect(page).to have_content "Hello 8"
    expect(page).to have_content "Hello 9"
    expect(page).to have_content "Hello 10"
  end

  it 'creates a new card' do
    visit cards_path
    expect(page).to have_content 'Cards#index'
    click_on '新規作成'
    fill_in '気になるフレーズ', with: '本日は晴天なり'
    click_on '翻訳する'
    expect(page).to have_content 'Cards#index'
    expect(page).to have_content '本日は晴天なり'
    expect(page).to have_content 'testing a microphone'
  end

  it 'display a details page of cards' do
    card = FactoryBot.create(:card)

    visit cards_path
    click_on card.ja_phrase
    expect(page).to have_content 'Cards#show'
    expect(page).to have_content 'こんにちは 19'
    expect(page).to have_content 'Hello 17'
    visit cards_path
    click_on card.en_phrase
    expect(page).to have_content 'Cards#show'
    expect(page).to have_content 'こんにちは 19'
    expect(page).to have_content 'Hello 17'
  end

  it 'deletes a card', :js do
    card = FactoryBot.create(:card)

    visit card_path(card)
    accept_confirm "本当に削除しますか？" do
      click_on '削除する'
    end
    expect(page).to have_content 'Cards#index'
    expect(page).not_to have_content 'こんにちは 23'
    expect(page).not_to have_content 'Hello 21'
  end

  it 'updates a card' do
    card = FactoryBot.create(:card)

    visit cards_path
    expect(page).to have_content "Cards#index"

    click_on '編集する', match: :first
    fill_in '日本語', with: 'カードを更新した'
    fill_in '英語', with: 'Updated card'
    click_on '更新する'
    expect(page).to have_content 'Cards#index'
    expect(page).to have_content 'カードを更新した'
    expect(page).to have_content 'Updated card'
  end

  it 'can review unmemorized cards in review mode', :js do
    unmemorized_card1 = FactoryBot.create(:card, :unmemorized1)
    unmemorized_card2 = FactoryBot.create(:card, :unmemorized2)

    visit review_cards_path
    expect(page).to have_content '復習モード'
    expect(page).to have_content 'もう少し。でも、まだ暗記できていない'
    expect(page).not_to have_content 'Almost there. But I haven\'t memorized it yet.'
    click_on '英文を表示する'
    expect(page).to have_content 'I haven\'t memorized it yet.'
    click_on '英文を隠す'
    expect(page).not_to have_content 'I haven\'t memorized it yet.'
    click_on '次のカードへ'
    expect(page).to have_content '復習モード'
    expect(page).to have_content 'まだ暗記できていない'
    expect(page).not_to have_content 'I haven\'t memorized it yet.'
    click_on '前のカードへ'
    expect(page).to have_content '復習モード'
    expect(page).to have_content 'まだ暗記できていない'
    expect(page).not_to have_content 'I haven\'t memorized it yet.'
  end

  it 'a memorized button removes card from review mode', :js do
    card = FactoryBot.create(:card, :unmemorized1)
    card2 = FactoryBot.create(:card, :unmemorized2)
    visit cards_path
    expect(page).to have_content 'もう少し。でも、まだ暗記できていない'
    expect(page).to have_content 'Almost there. But I haven\'t memorized it yet.'
    within "#card-#{card2.id}" do
      click_on '覚えた！'
      expect(page).to have_content("忘れた！", wait: 7)
    end
    visit review_cards_path
    expect(page).not_to have_content 'もう少し。でも、まだ暗記できていない'
    expect(page).to have_content 'まだ暗記できていない'
    expect(page).not_to have_content '次のカードへ'
  end
end
