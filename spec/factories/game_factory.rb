# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    active_player { :x }
    player { :x }
    trait :in_progress do
      state {
        [
          [nil, nil,  nil],
          [nil, :x,   nil],
          [:o,  nil,  nil]
        ]
      }
    end

    trait :nearly_won do
      state {
        [
          [nil, nil,  nil],
          [:x,  nil,  :x],
          [:o,  nil,  :o]
        ]
      }
    end

    trait :won do
      winner { :x }
      over { true }
      state {
        [
          [nil, nil,  nil],
          [:x,  :x,   :x],
          [:o,  nil,  :o]
        ]
      }
    end

    trait :draw do
      over { true }
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
