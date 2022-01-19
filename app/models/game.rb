require 'seed'
require 'uuid'
require 'word_picker'

class Game < ApplicationRecord
  broadcasts

  enum status: { ongoing: "ongoing", done: "done" }, _prefix: true

  validates :uuid, presence: true, uniqueness: true
  validates :status, presence: true
  validates :seed, presence: true

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

  attr_readonly :seed, :uuid

  before_validation :set_seed, :set_uuid

  after_create :create_words!

  has_many :words, dependent: :destroy

  def compute_score
    words.eager_load(:attempts).inject(0) do |memo, word|
      memo + word.compute_score(max_attempts)
    end
  end

  private

  def create_words!
    WordPicker.new(self).pick_words.each.with_index do |to_guess, i|
      words.create!(to_guess: to_guess, status: i == 0 ? 'ongoing' : 'not_started')
    end
  end

  def set_seed
    self.seed ||= Seed.generate
  end

  def set_uuid
    self.uuid ||= UUID.generate
  end
end
