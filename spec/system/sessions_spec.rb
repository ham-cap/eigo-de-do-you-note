require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { FactoryBot.create(:user) }

  it 'user log in', :js do
    log_in_as user
    expect(page).to have_content 'ログインしました'
  end

  it 'user fails to log in' do
    OmniAuth.configure do |config|
      config.test_mode = true
      config.mock_auth[:google_oauth2] =
        OmniAuth::AuthHash.new({
                                 provider: '',
                                 uid: '',
                                 info: { name: '' }
                               })
    end
    visit root_path
    click_on 'Googleでログイン', match: :first

    expect(page).to have_content 'ログインに失敗しました'
  end

  it 'user log out', :js do
    Capybara.using_session("another_session_in_sessions_spec") do
      log_in_as user
      expect(page).to have_content 'ログインしました'
      find_by_id('menu-close').click
      within "#menu-open" do
        click_on 'ログアウト'
      end
      expect(page).to have_content '翻訳と記録を同時にしてくれるアプリです。'
      expect(page).to have_content 'ログアウトしました'
    end
  end
end
