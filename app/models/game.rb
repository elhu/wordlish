class Game < ApplicationRecord
  enum status: { ongoing: "ongoing", done: "done" }, _prefix: true
end
