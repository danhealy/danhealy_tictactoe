# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength, Style/BlockDelimiters, Style/SymbolArray
FactoryBot.define do
  factory :game do
    active_player { :x }
    trait :in_progress do
      state {
        [
          [nil, nil,  nil],
          [nil, :x,   nil],
          [:o,  nil,  nil]
        ]
      }
    end

    trait :won do
      state {
        [
          [nil, nil,  :o],
          [:x,  :x,   :x],
          [:o,  nil,  :o]
        ]
      }
    end

    trait :draw do
      state {
        [
          [:x, :o, :o],
          [:o, :x, :x],
          [:o, :x, :o]
        ]
      }
    end
  end
end
# rubocop:enable Metrics/BlockLength, Style/BlockDelimiters, Style/SymbolArray
