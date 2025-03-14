require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { FactoryBot.create(:user) }

  it 'a user withdrawals', :js do
    Capybara.using_session("another_session_in_users_spec") do
      log_in_as user
      find_by_id('menu-close').click
      expect(page).to have_content '退会'
      accept_confirm '退会すると今まで作成したカードは全て削除されます。退会してよろしいですか？' do
        click_on '退会'
      end
      expect(page).to have_content '翻訳と記録を同時にしてくれる'
      expect(page).to have_content '英語フレーズ帳'
      expect(page).to have_content '退会しました'
    end
  end
end
