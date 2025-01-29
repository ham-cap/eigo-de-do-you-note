require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { FactoryBot.create(:user) }

  it 'a user log in', :js do
    log_in_as user
    expect(page).to have_content 'ログインしました'
  end

  it 'a user log out', :js do
    log_in_as user
    expect(page).to have_content 'ログインしました'
    click_on 'hamburger_menu_icon'
    expect(page).to have_content 'ログアウト'
    click_on 'ログアウト'
    expect(page).to have_content 'Home#index'
    expect(page).to have_content 'ログアウトしました'
  end
end
