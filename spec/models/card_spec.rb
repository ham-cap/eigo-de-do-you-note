require 'rails_helper'

RSpec.describe Card, type: :model do
  it 'is valid with ja_phrase, en_phrase and memorized_at' do
    expect(FactoryBot.build(:card)).to be_valid
  end

  it 'is invalid without ja_phrase' do
    card = FactoryBot.build(:card, :without_ja_phrase)
    card.valid?
    expect(card.errors[:ja_phrase]).to include('can\'t be blank')
  end

  it 'is invalid without en_phrase' do
    card = FactoryBot.build(:card, :without_en_phrase)
    card.valid?
    expect(card.errors[:en_phrase]).to include('can\'t be blank')
  end

  it 'does not allow duplicate combinations of ja_phrase and en_phrase' do
    card1 = FactoryBot.create(:card)
    card2 = FactoryBot.build(:card, :has_the_same_combination)
    card2.valid?
    expect(card2.errors[:ja_phrase]).to include('has already been taken')
  end

  it 'can share the same Japanese phrase between defferent cards' do
    card1 = FactoryBot.create(:card)
    card2 = FactoryBot.build(:card, :same_word_in_ja_phrase)
    card2.valid?
    expect(card2.errors[:ja_phrase]).not_to include('has already been taken')
  end

  it 'can share the same Englesh phrase between defferent cards' do
    card1 = FactoryBot.create(:card)
    card2 = FactoryBot.build(:card, :same_word_in_en_phrase)
    card2.valid?
    expect(card2.errors[:en_phrase]).not_to include('has already been taken')
  end
end
