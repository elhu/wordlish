class Word < ApplicationRecord
  belongs_to :game

  enum status: { not_started: "not_started", ongoing: "ongoing", done: "done" }, _prefix: true

  validates :to_guess, presence: true
  validates :score, presence: true, numericality: { only_integer: true }
  validates :status, presence: true

  validate :word_length_must_match_game

  attr_readonly :to_guess

  def word_length_must_match_game
    return unless (to_guess || "").length != game&.word_length

    errors.add(:to_guess, "must match length configured in game")
  end
end
