require 'rails_helper'

RSpec.describe "Cards", type: :system do
  before do
    driven_by(:rack_test)
    @cards = []
    3.times do
      @cards << FactoryBot.create(:card)
    end
  end

  it 'display a list of cards' do
    visit cards_path
    expect(page).to have_content "Cards#index"
    expect(page).to have_content "こんにちは 8"
    expect(page).to have_content "こんにちは 9"
    expect(page).to have_content "こんにちは 10"
    expect(page).to have_content "Hello 8"
    expect(page).to have_content "Hello 9"
    expect(page).to have_content "Hello 10"
  end
end
