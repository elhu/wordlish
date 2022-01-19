require 'word_picker'

class Word < ApplicationRecord
  belongs_to :game
  has_many :attempts, dependent: :destroy

  enum status: { not_started: "not_started", ongoing: "ongoing", done: "done" }, _prefix: true

  validates :to_guess, presence: true
  validates :score, presence: true, numericality: { only_integer: true }
  validates :status, presence: true

  validate :word_length_must_match_game, :word_must_exist

  attr_readonly :to_guess

  def compute_score(max_attempts)
    score = max_attempts - attempts.to_a.count
    score += 10 if attempts.last&.guess == to_guess
    score
  end

  private

  def word_length_must_match_game
    return unless (to_guess || "").length != game&.word_length

    errors.add(:to_guess, "must match length configured in game")
  end

  def word_must_exist
    return if WordPicker.exists?(to_guess)

    errors.add(:to_guess, "must be in the dictionary")
  end
end
