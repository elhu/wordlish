class Attempt < ApplicationRecord
  belongs_to :word

  validates :guess, presence: true
  validates :position, presence: true, numericality: { only_integer: true }

  validate :guess_length_must_match_game

  attr_readonly :guess

  after_commit :broadcast_update

  private

  def broadcast_update
    broadcast_update_to(word, target: "word_#{word.id}_attempt_#{position}", locals: { word: word, attempt: self })
  end

  def guess_length_must_match_game
    return unless (guess || "").length != word&.game&.word_length

    errors.add(:guess, "must match length configured in game")
  end
end
