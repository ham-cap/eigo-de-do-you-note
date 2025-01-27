require 'rails_helper'

RSpec.describe "Cards", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:cards) { FactoryBot.create_list(:card, 3, user: user) }

  before do
    log_in_as user
    expect(page).to have_content('ログインしました', wait: 10)
    expect(page).to have_content("Cards#index", wait: 10)
  end

  it 'displays a list of cards', :js do
    expect(page).to have_content 'Cards#index'
    expect(page).to have_content cards[0].ja_phrase
    expect(page).to have_content cards[0].en_phrase
    expect(page).to have_content cards[1].ja_phrase
    expect(page).to have_content cards[1].en_phrase
    expect(page).to have_content cards[2].ja_phrase
    expect(page).to have_content cards[2].en_phrase
  end

  it 'creates a new card', :js do
    visit cards_path
    expect(page).to have_content 'Cards#index'
    click_on '新規作成'
    fill_in '気になるフレーズ', with: '本日は晴天なり'
    click_on '翻訳する'
    expect(page).to have_content('Cards#index', wait: 10)
    expect(page).to have_content('本日は晴天なり', wait: 10)
    expect(page).to have_content('testing a microphone', wait: 10)
  end

  it 'display a details page of cards', :js do
    visit cards_path
    expect(page).to have_content "Cards#index"
    click_on cards[0].ja_phrase
    expect(page).to have_content 'Cards#show'
    expect(page).to have_content cards[0].ja_phrase
    expect(page).to have_content cards[0].en_phrase
    expect(page).not_to have_content cards[1].ja_phrase
    expect(page).not_to have_content cards[1].en_phrase
  end

  it 'deletes a card', :js do
    visit card_path(cards[0])
    expect(page).to have_content cards[0].ja_phrase
    expect(page).to have_content cards[0].en_phrase
    expect(page).to have_content 'Cards#show'
    accept_confirm "本当に削除しますか？" do
      click_on '削除する'
    end
    expect(page).to have_content 'Cards#index'
    expect(page).not_to have_content cards[0].ja_phrase
    expect(page).not_to have_content cards[0].en_phrase
  end

  it 'updates a card', :js do
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
    unmemorized_card1 = FactoryBot.create(:card, :unmemorized1, user: user)
    unmemorized_card2 = FactoryBot.create(:card, :unmemorized2, user: user)

    visit review_cards_path
    expect(page).to have_content '復習モード'
    expect(page).to have_content 'もう少し。でも、まだ暗記できていない'
    expect(page).not_to have_content 'Almost there. But I haven\'t memorized it yet.'
    click_on '英文を表示する'
    expect(page).to have_content 'Almost there. But I haven\'t memorized it yet.'
    click_on '英文を隠す'
    expect(page).not_to have_content 'Almost there. But I haven\'t memorized it yet.'
    click_on '次のカードへ'
    expect(page).to have_content '復習モード'
    expect(page).to have_content 'まだ暗記できていない'
    expect(page).not_to have_content 'I haven\'t memorized it yet.'
    click_on '前のカードへ'
    expect(page).to have_content '復習モード'
    expect(page).to have_content 'もう少し。でも、まだ暗記できていない'
    expect(page).not_to have_content 'Almost there. But I haven\'t memorized it yet.'
  end

  it 'a memorized button removes card from review mode', :js do
    unmemorized_card1 = FactoryBot.create(:card, :unmemorized1, user: user)
    unmemorized_card2 = FactoryBot.create(:card, :unmemorized2, user: user)
    visit cards_path
    expect(page).to have_content 'もう少し。でも、まだ暗記できていない'
    expect(page).to have_content 'Almost there. But I haven\'t memorized it yet.'
    within "#card-#{unmemorized_card2.id}" do
      click_on '覚えた！'
      expect(page).to have_content "忘れた！"
    end
    click_on '復習モードへ'
    expect(page).not_to have_content 'もう少し。でも、まだ暗記できていない'
    expect(page).to have_content 'まだ暗記できていない'
    expect(page).not_to have_content '次のカードへ'
  end

  it 'can be searched incrementally', :js do
    card = FactoryBot.create(:card, :for_incremental_search_test, user: user)
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
    memorized_card = FactoryBot.create(:card, user: user)
    unmemorized_card = FactoryBot.create(:card, :unmemorized1, user: user)
    visit cards_path
    click_on '覚えたカード'
    expect(page).to have_content memorized_card.ja_phrase
    expect(page).not_to have_content unmemorized_card.ja_phrase
    click_on 'まだ覚えていないカード'
    expect(page).not_to have_content memorized_card.ja_phrase
    expect(page).to have_content unmemorized_card.ja_phrase
  end

  it 'can use infinite scroll in cards index page', :js do
    n = 1
    45.times do
      FactoryBot.create(:card, ja_phrase: "カード #{n}", user: user)
      n += 1
    end
    visit cards_path
    expect(page).not_to have_content('カード 1', wait: 10)
    page.execute_script("window.scrollTo(0, document.body.scrollHeight)")
    expect(page).to have_content('カード 1', wait: 10)
  end

  it 'spinner show up while card creation', :js do
    visit cards_path
    click_on '新規作成'
    fill_in '気になるフレーズ', with: '本日は晴天なり'
    click_on '翻訳する'
    expect(page).to have_content('Now translating...', wait: 10)
    expect(page).to have_selector('.spinner', wait: 10)
    expect(page).to have_content('本日は晴天なり', wait: 10)
    expect(page).to have_content('testing a microphone', wait: 10)
  end

  it 'user can log out', :js do
    click_on 'hamburger_menu_icon'
    expect(page).to have_selector('.header-dropdown__items', wait: 10)
    expect(page).to(have_content 'ログアウト', wait: 10)
    click_on 'ログアウト'
    expect(page).to have_content 'Home#index'
    expect(page).to have_content 'ログアウトしました'
  end

  it 'user can withdrawal', :js do
    click_on 'hamburger_menu_icon'
    expect(page).to have_selector('.header-dropdown__items', wait: 10)
    expect(page).to have_content('退会', wait: 10)
    accept_confirm '退会すると今まで作成したカードは全て削除されます。退会してよろしいですか？' do
      click_on '退会'
    end
    expect(page).to have_content 'Home#index'
    expect(page).to have_content '退会しました'
  end
end
