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
      expect(page).to have_content 'ログインしました'
    end

    it 'visit terms page', :js do
      find_by_id('menu-close').click
      expect(page).to have_no_css('#menu-open.hidden', wait: 20)
      click_on '利用規約', match: :first
      expect(page).to have_css 'h1', text: '利用規約'
    end

    it 'visit privacy policy page', :js do
      find_by_id('menu-close').click
      expect(page).to have_no_css('#menu-open.hidden', wait: 20)
      click_on 'プライバシーポリシー', match: :first
      expect(page).to have_css 'h1', text: 'プライバシーポリシー'
    end
  end
end
