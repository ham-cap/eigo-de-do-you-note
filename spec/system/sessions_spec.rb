require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { FactoryBot.create(:user) }

  it 'a user log in', :js do
    log_in_as user
    expect(page).to have_content 'ログインしました'
  end

  it 'a user log out', :js do
    Capybara.using_session("another_session_in_sessions_spec") do
      log_in_as user
      expect(page).to have_content 'ログインしました'
      find_by_id('menu-close').click
      within "#menu-open" do
        click_on 'ログアウト'
      end
      expect(page).to have_content 'Home#index'
      expect(page).to have_content 'ログアウトしました'
    end
  end
end
