class BibleReading < ApplicationRecord
  validates :book, presence: true
  validates :uid, presence: true
end
