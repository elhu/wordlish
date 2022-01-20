class Attempt < ApplicationRecord
  belongs_to :word

  validates :guess, presence: true
  validates :position, presence: true, numericality: { only_integer: true }

  validate :guess_length_must_match_game

  attr_readonly :guess

  private

  def guess_length_must_match_game
    return unless (guess || "").length != word&.game&.word_length

    errors.add(:guess, "must match length configured in game")
  end
end
