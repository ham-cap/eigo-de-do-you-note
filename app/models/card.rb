class Card < ApplicationRecord
  validates :ja_phrase, presence: true
  validates :en_phrase, presence: true
  validates :ja_phrase, uniqueness: { scope: :en_phrase }
end
