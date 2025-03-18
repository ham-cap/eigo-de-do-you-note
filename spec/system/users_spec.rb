require 'rails_helper'

RSpec.describe "Users", type: :system do
  it 'a user withdrawals' do
    user = create(:user)

    log_in_as user
    find_by_id('menu-close').click
    expect(page).to have_content '退会'
    expect {
      accept_confirm '退会すると今まで作成したカードは全て削除されます。退会してよろしいですか？' do
        click_on '退会'
      end
      expect(page).to have_content '退会しました'
    }.to change { User.count }.by(-1)

    expect(page).to have_content '翻訳と記録を同時にしてくれる'
    expect(page).to have_content '英語フレーズ帳'
  end
end
