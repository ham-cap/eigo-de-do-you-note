FactoryBot.define do
  factory :card do
    sequence(:ja_phrase) { |n| "こんにちは #{n}" }
    sequence(:en_phrase) { |n| "Hello #{n}" }
    memorized_at { "2024-12-13 15:33:42" }
    association :user

    trait :without_any_phrases do
      ja_phrase { nil }
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

    trait :unmemorized1 do
      ja_phrase { 'まだ暗記できていない' }
      en_phrase { 'I haven\'t memorized it yet.' }
      memorized_at { nil }
    end

    trait :unmemorized2 do
      ja_phrase { 'もう少し。でも、まだ暗記できていない' }
      en_phrase { 'Almost there. But I haven\'t memorized it yet.' }
      memorized_at { nil }
    end

    trait :for_incremental_search_test do
      ja_phrase { 'カード一覧画面ではインクリメンタルサーチが使用できます。' }
      en_phrase { 'Incremental search is available on the card list screen.' }
      memorized_at { nil }
    end

    trait :belonging_to_another_user do
      ja_phrase { '他のユーザーが作成したカードです' }
      en_phrase { 'Cards created by other users.' }
      memorized_at { nil }
      association :user, factory: [:user, :another_user]
    end
  end
end
