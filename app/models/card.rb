class Card < ApplicationRecord
  attr_accessor :source_language
  belongs_to :user

  validate :either_ja_or_en_must_be_present
  validates :ja_phrase, presence: true, uniqueness: { scope: [:en_phrase, :user_id] }
  validates :ja_phrase, length: { maximum: 100 }, if: ->(card) { card.source_language == 'ja' }
  validates :en_phrase, presence: true
  validates :en_phrase, length: { maximum: 200 }, if: ->(card) { card.source_language == 'en' }

  scope :memorized, -> { where.not(memorized_at: nil) }
  scope :unmemorized, -> { where(memorized_at: nil) }

  class << self
    def generate_a_translated_and_source_text_pair(original_text, user)
      source_language = CLD.detect_language(original_text)[:code]
      target_language = source_language == 'ja' ? 'EN' : 'JA'
      translated_sentence = DeepL.translate(original_text, nil, target_language) if original_text.present?

      if source_language == 'ja'
        user.cards.build(ja_phrase: original_text,
                         en_phrase: translated_sentence,
                         source_language:)
      else
        user.cards.build(ja_phrase: translated_sentence,
                         en_phrase: original_text,
                         source_language:)
      end
    end

    def ransackable_attributes(auth_object = nil)
      %w[id ja_phrase en_phrase memorized_at created_at updated_at user_id]
    end

    def ransackable_associations(auth_object = nil)
      %w[user]
    end
  end

  private

  def either_ja_or_en_must_be_present
    if ja_phrase.blank? || en_phrase.blank?
      errors.add(:base, 'フレーズを入力してください。')
    end
  end
end
