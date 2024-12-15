FactoryBot.define do
  factory :card do
    ja_phrase { "こんにちは" }
    en_phrase { "Hello" }
    memorized_at { "2024-12-13 15:33:42" }

    trait :without_ja_phrase do
      ja_phrase { nil }
    end

    trait :without_en_phrase do
      en_phrase { nil }
    end

    trait :same_word_in_ja_phrase do
      en_phrase { 'Hola' }
    end

    trait :same_word_in_en_phrase do
      en_phrase { 'こんばんは' }
    end
  end
end
