class Campaign < ApplicationRecord
  has_many :investments
  attribute :percentage_raised, default: 0

  validates :name, uniqueness: {case_sensitive: true}, presence: true
  validates :target_amount, presence: true, numericality: { greater_than: 0}
end
