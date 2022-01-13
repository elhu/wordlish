class Game < ApplicationRecord
  enum status: { ongoing: "ongoing", done: "done" }, _prefix: true

  validates :uuid, presence: true, uniqueness: true
  validates :status, presence: true
end
