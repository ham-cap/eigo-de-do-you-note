FactoryBot.define do
  factory :card do
    sequence(:ja_phrase) { |n| "こんにちは #{n}" }
    sequence(:en_phrase) { |n| "Hello #{n}" }
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

    trait :has_the_same_combination do
      ja_phrase { 'こんにちは 3' }
      en_phrase { 'Hello 3' }
    end
  end
end
