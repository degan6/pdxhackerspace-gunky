class LogEntry < ApplicationRecord
  CATEGORIES = %w[upload slack ai].freeze

  validates :category, inclusion: { in: CATEGORIES }
  validates :action, :message, presence: true

  scope :recent_first, -> { order(created_at: :desc) }
  scope :for_category, ->(category) { category.present? ? where(category: category) : all }
end
