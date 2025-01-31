require 'rails_helper'

RSpec.describe "Cards", type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe 'not logged in' do
    it 'visit terms page', :js do
      visit root_path
      click_on '利用規約'
      expect(page).to have_css 'h1', text: '利用規約'
    end

    it 'visit privacy policy page', :js do
      visit root_path
      click_on 'プライバシーポリシー'
      expect(page).to have_css 'h1', text: 'プライバシーポリシー'
    end
  end

  describe 'logged in', :js do
    before do
      log_in_as user
    end

    it 'visit terms page', :js do
      expect(page).to have_content 'ログインしました'
      click_on 'hamburger_menu_icon'
      within('#menu-open') do
        click_on '利用規約'
      end
      expect(page).to have_css 'h1', text: '利用規約'
    end

    it 'visit privacy policy page', :js do
      expect(page).to have_content 'ログインしました'
      click_on 'hamburger_menu_icon'
      within('#menu-open') do
      click_on 'プライバシーポリシー'
      end
      expect(page).to have_css 'h1', text: 'プライバシーポリシー'
    end
  end
end
