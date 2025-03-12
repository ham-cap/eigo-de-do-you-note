require 'rails_helper'

RSpec.describe "Cards", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:cards) { FactoryBot.create_list(:card, 3, user: user) }
  let(:card_belonging_to_another_user) { FactoryBot.create(:card, :belonging_to_another_user) }

  before do
    log_in_as user
    expect(page).to have_content('ログインしました', wait: 10)
    expect(page).to have_content('フレーズ一覧', wait: 10)
  end

  scenario 'a user visits the card list', :js do
    expect(page).to have_content 'フレーズ一覧'
    expect(page).to have_content cards[0].ja_phrase
    expect(page).to have_content cards[0].en_phrase
    expect(page).to have_content cards[1].ja_phrase
    expect(page).to have_content cards[1].en_phrase
    expect(page).to have_content cards[2].ja_phrase
    expect(page).to have_content cards[2].en_phrase
  end

  scenario 'a user creates a new card with Japanese', :js do
    visit cards_path
    expect(page).to have_content 'フレーズ一覧'
    find('.creation_icon').click
    fill_in '翻訳したいフレーズ', with: '本日は晴天なり'
    click_on '翻訳する'
    expect(page).to have_content('カードを作成しました', wait: 10)
    expect(page).to have_content('フレーズ一覧', wait: 10)
    expect(page).to have_content('本日は晴天なり', wait: 10)
    expect(page).to have_content('testing a microphone', wait: 10)
  end

  scenario 'a user creates a new card with English', :js do
    visit cards_path
    expect(page).to have_content 'フレーズ一覧'
    find('.creation_icon').click
    fill_in '翻訳したいフレーズ', with: 'Failure teaches success.'
    click_on '翻訳する'
    expect(page).to have_content('カードを作成しました', wait: 10)
    expect(page).to have_content('フレーズ一覧', wait: 10)
    expect(page).to have_content('失敗は成功を教えてくれる。', wait: 10)
    expect(page).to have_content('Failure teaches success.', wait: 10)
  end

  scenario 'a user fails to create a new card', :js do
    visit cards_path
    expect(page).to have_content 'フレーズ一覧'
    find('.creation_icon').click
    fill_in '翻訳したいフレーズ', with: ''
    click_on '翻訳する'
    expect(page).to have_content('フレーズを入力してください。', wait: 10)
  end

  scenario 'a user deletes a card from show page', :js do
    visit card_path(cards[0])
    expect(page).to have_content cards[0].ja_phrase
    expect(page).to have_content cards[0].en_phrase
    expect(page).to have_content '詳細'
    click_on '編集する'
    accept_confirm "本当に削除しますか？" do
      click_on '削除する'
    end
    expect(page).to have_content('フレーズ一覧', wait: 10)
    expect(page).not_to have_content cards[0].ja_phrase
    expect(page).not_to have_content cards[0].en_phrase
  end

  scenario 'a user deletes a card from card list', :js do
    expect(page).to have_content 'フレーズ一覧'
    within "#card-#{cards[0].id}" do
      click_on '編集する'
    end
    accept_confirm "本当に削除しますか？" do
      click_on '削除する'
    end
    expect(page).to have_content('フレーズ一覧', wait: 10)
    expect(page).not_to have_content cards[0].ja_phrase
    expect(page).not_to have_content cards[0].en_phrase
  end

  scenario 'a user updates a card', :js do
    visit cards_path
    expect(page).to have_content "フレーズ一覧"
    click_on '編集する', match: :first
    fill_in 'card[ja_phrase]', with: 'カードを更新した'
    fill_in 'card[en_phrase]', with: 'Updated card'
    click_on '更新する'
    expect(page).to have_content 'フレーズ一覧'
    expect(page).to have_content 'カードを更新した'
    expect(page).to have_content 'Updated card'
  end

  scenario 'a user fails to update a card', :js do
    visit cards_path
    expect(page).to have_content "フレーズ一覧"
    click_on '編集する', match: :first
    fill_in 'card[ja_phrase]', with: ''
    fill_in 'card[en_phrase]', with: ''
    click_on '更新する'
    expect(page).to have_content('フレーズを入力してください。', wait: 15)
  end

  scenario 'a user reviews unmemorized cards in review mode', :js do
    unmemorized_card1 = FactoryBot.create(:card, :unmemorized1, user: user)
    unmemorized_card2 = FactoryBot.create(:card, :unmemorized2, user: user)

    visit review_cards_path
    expect(page).to have_content '復習モード'
    expect(page).to have_content 'もう少し。でも、まだ暗記できていない'
    expect(page).not_to have_content 'Almost there. But I haven\'t memorized it yet.'
    click_on '英文を表示'
    expect(page).to have_content 'Almost there. But I haven\'t memorized it yet.'
    click_on '英文を隠す'
    expect(page).not_to have_content 'Almost there. But I haven\'t memorized it yet.'
    click_on '次のフレーズへ'
    expect(page).to have_content '復習モード'
    expect(page).to have_content 'まだ暗記できていない'
    expect(page).not_to have_content 'I haven\'t memorized it yet.'
    click_on '前のフレーズへ'
    expect(page).to have_content '復習モード'
    expect(page).to have_content 'もう少し。でも、まだ暗記できていない'
    expect(page).not_to have_content 'Almost there. But I haven\'t memorized it yet.'
  end

  scenario 'a user removes a card from review mode by clicking a check button', :js do
    Capybara.using_session("another_session_in_cards_spec") do
      log_in_as user
      unmemorized_card1 = FactoryBot.create(:card, :unmemorized1, user: user)
      unmemorized_card2 = FactoryBot.create(:card, :unmemorized2, user: user)
      visit cards_path
      expect(page).to have_content unmemorized_card2.ja_phrase
      expect(page).to have_content unmemorized_card2.en_phrase
      within "#card-#{unmemorized_card2.id}" do
        find('#memorized-button').click
      end
      find_by_id('menu-close').click
      expect(page).to have_no_css('#menu-open.hidden', wait: 20)
      within('#menu-open') do
        click_on '復習モード'
      end
      expect(page).to have_content '復習モード'
      expect(page).not_to have_content unmemorized_card2.ja_phrase
      expect(page).not_to have_content '次のフレーズへ'
    end
  end

  scenario 'a user add a card to review mode by clicking a check button', :js do
    card = FactoryBot.create(:card, user: user)
    visit cards_path
    expect(page).to have_content card.ja_phrase
    expect(page).to have_content card.en_phrase
    within "#card-#{card.id}" do
      find('#memorized-button').click
    end
    find_by_id('menu-close').click
    expect(page).to have_no_css('#menu-open.hidden', wait: 20)
    within('#menu-open') do
      click_on '復習モード'
    end
    expect(page).to have_content '復習モード'
    expect(page).to have_content card.ja_phrase
  end

  scenario 'a user search for cards using incremental search', :js do
    card = FactoryBot.create(:card, :for_incremental_search_test, user: user)
    visit cards_path
    fill_in 'フレーズを検索', with: 'インクリメンタル'
    expect(page).to have_content 'カード一覧画面ではインクリメンタルサーチが使用できます。'
    expect(page).to have_selector('.a-card', count: 1)
    visit cards_path
    fill_in 'フレーズを検索', with: 'incremental'
    expect(page).to have_content 'Incremental search is available on the card list screen.'
    expect(page).to have_selector('.a-card', count: 1)
  end

  scenario 'a user filter the card list', :js do
    memorized_card = FactoryBot.create(:card, user: user)
    unmemorized_card = FactoryBot.create(:card, :unmemorized1, user: user)
    visit cards_path
    within '.filters' do
      click_on '覚えた'
    end
    expect(page).to have_content memorized_card.ja_phrase
    expect(page).not_to have_content unmemorized_card.ja_phrase
    click_on '覚えていない'
    expect(page).not_to have_content memorized_card.ja_phrase
    expect(page).to have_content unmemorized_card.ja_phrase
  end

  scenario 'the spinner show up while card creation', :js do
    visit cards_path
    find('.creation_icon').click
    fill_in '翻訳したいフレーズ', with: '本日は晴天なり'
    click_on '翻訳する'
    expect(page).to have_content('Now translating...', wait: 10)
    expect(page).to have_selector('.spinner', wait: 10)
    expect(page).to have_content('本日は晴天なり', wait: 10)
    expect(page).to have_content('testing a microphone', wait: 10)
  end

  scenario 'a user can\'t access the cards belonging to other users', :js do
    visit card_path(card_belonging_to_another_user)
    expect(page).to have_content('ActiveRecord::RecordNotFound in CardsController#show')
  end

  scenario 'user cannot access to card list before login', :js do
    log_out
    visit cards_path
    expect(page).to have_content('ログインしてください')
  end
end
