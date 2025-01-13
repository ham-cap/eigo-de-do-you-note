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
    expect(page).to have_content('本日は晴天なり', wait: 5)
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
      expect(page).to have_content("忘れた！", wait: 10)
    end
    visit review_cards_path
    expect(page).not_to have_content('もう少し。でも、まだ暗記できていない', wait: 20)
    expect(page).to have_content 'まだ暗記できていない'
    expect(page).not_to have_content '次のカードへ'
  end

  it 'can be searched incrementally', :js do
    card = FactoryBot.create(:card, :for_incremental_search_test)
    visit cards_path
    fill_in 'カードを検索', with: 'インクリメンタル'
    expect(page).to have_content 'カード一覧画面ではインクリメンタルサーチが使用できます。'
    expect(page).to have_selector('.a-card', count: 1)
    visit cards_path
    fill_in 'カードを検索', with: 'incremental'
    expect(page).to have_content 'Incremental search is available on the card list screen.'
    expect(page).to have_selector('.a-card', count: 1)
  end

  it 'can use filter in card list', :js do
    memorized_card = FactoryBot.create(:card)
    unmemorized_card = FactoryBot.create(:card, :unmemorized1)
    visit cards_path
    click_on '覚えたカード'
    expect(page).to have_content memorized_card.ja_phrase
    expect(page).not_to have_content unmemorized_card.ja_phrase
    click_on 'まだ覚えていないカード'
    expect(page).not_to have_content memorized_card.ja_phrase
    expect(page).to have_content unmemorized_card.ja_phrase
  end

  it 'can use pagination in card list', :js do
    n = 1
    26.times do
      FactoryBot.create(:card, ja_phrase: "カード #{n}")
      n += 1
    end
    visit cards_path
    click_on 'Next ›', match: :first
    expect(page).to have_content('カード 1', wait: 10)
  end

  it 'can use user menu', :js do
    visit cards_path
    click_on 'ユーザーメニュー'
    expect(page).to have_content('ログアウト')
    expect(page).to have_content('退会')
    click_on 'ユーザーメニュー'
    expect(page).not_to have_content('ログアウト')
    expect(page).not_to have_content('退会')
  end

  it 'can move to top page from footer link', :js do
    card = FactoryBot.create(:card)
    visit card_path(card)
    expect(page).to have_content('トップページ')
    click_on 'トップページ'
    expect(page).to have_content "Cards#index"
  end

  it 'spinner show up while card creation', :js do
    visit cards_path
    click_on '新規作成'
    fill_in '気になるフレーズ', with: '本日は晴天なり'
    click_on '翻訳する'
    expect(page).to have_content('Now translating...')
    expect(page).to have_selector('.spinner')
    expect(page).to have_content('本日は晴天なり', wait: 5)
    expect(page).to have_content 'testing a microphone'
  end
end
