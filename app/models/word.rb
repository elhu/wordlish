class Word < ApplicationRecord
  belongs_to :game

  validates :to_guess, presence: true
  validates :score, presence: true, numericality: { only_integer: true }

  validate :word_length_must_match_game

  def word_length_must_match_game
    return unless (to_guess || "").length != game&.word_length

    errors.add(:to_guess, "must match length configured in game")
  end
end
