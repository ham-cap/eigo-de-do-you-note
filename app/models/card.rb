class Card < ApplicationRecord
  belongs_to :user

  validates :ja_phrase, presence: true
  validates :en_phrase, presence: true
  validates :ja_phrase, uniqueness: { scope: :en_phrase }

  scope :memorized, -> { where.not(memorized_at: nil) }
  scope :unmemorized, -> { where(memorized_at: nil) }
end
