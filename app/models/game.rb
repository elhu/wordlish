require 'uuid'

class Game < ApplicationRecord
  enum status: { ongoing: "ongoing", done: "done" }, _prefix: true

  validates :uuid, presence: true, uniqueness: true
  validates :status, presence: true

  before_validation :set_uuid

  private

  def set_uuid
    self.uuid ||= UUID.generate
  end
end
