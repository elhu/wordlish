require 'uuid'

class Game < ApplicationRecord
  broadcasts

  enum status: { ongoing: "ongoing", done: "done" }, _prefix: true

  validates :uuid, presence: true, uniqueness: true
  validates :status, presence: true
  validates :score,
            presence: true,
            numericality: { only_integer: true }

  validates :word_length,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 3, less_than_or_equal_to: 16 }
  validates :max_words,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 10, less_than_or_equal_to: 50 }
  validates :max_attempts,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 4, less_than_or_equal_to: 10 }

  attr_readonly :uuid

  before_validation :set_uuid

  private

  def set_uuid
    self.uuid ||= UUID.generate
  end
end
