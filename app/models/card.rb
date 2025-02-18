class Card < ApplicationRecord
  attr_accessor :input_lang
  belongs_to :user

  validates :ja_phrase, presence: true, uniqueness: { scope: :en_phrase }
  validates :ja_phrase, length: { maximum: 100 }, if: ->(card) { card.input_lang == 'ja' }
  validates :en_phrase, presence: true
  validates :en_phrase, length: { maximum: 200 }, if: ->(card) { card.input_lang == 'en' }

  scope :memorized, -> { where.not(memorized_at: nil) }
  scope :unmemorized, -> { where(memorized_at: nil) }

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[id ja_phrase en_phrase memorized_at created_at updated_at user_id]
    end

    def ransackable_associations(auth_object = nil)
      %w[user]
    end
  end
end
