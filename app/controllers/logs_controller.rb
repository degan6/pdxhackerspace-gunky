class LogsController < ApplicationController
  include Pagy::Method

  before_action :require_admin

  FILTER_CATEGORIES = [
    [ "All", nil ],
    [ "Uploads", "upload" ],
    [ "Slack", "slack" ],
    [ "AI", "ai" ]
  ].freeze

  def index
    @category = params[:category].presence
    @category = nil unless LogEntry::CATEGORIES.include?(@category)

    entries = LogEntry.recent_first.for_category(@category)
    @pagy, @log_entries = pagy(:offset, entries)
  end
end
