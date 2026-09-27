module LogsHelper
  CATEGORY_BADGES = {
    "upload" => "bg-primary",
    "slack" => "bg-success",
    "ai" => "bg-info text-dark"
  }.freeze

  def log_entry_category_badge_class(category)
    CATEGORY_BADGES.fetch(category.to_s, "bg-secondary")
  end
end
