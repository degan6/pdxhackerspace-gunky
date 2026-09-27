class ActivityLog
  def self.record(category:, action:, message:, metadata: {}, ip_address: nil, user_agent: nil, succeeded: true)
    LogEntry.create!(
      category: category,
      action: action,
      message: message,
      metadata: metadata,
      ip_address: ip_address,
      user_agent: user_agent,
      succeeded: succeeded
    )
  rescue StandardError => e
    Rails.logger.error("ActivityLog failed (#{category}/#{action}): #{e.class}: #{e.message}")
    nil
  end

  def self.record_upload(action:, message:, request: nil, metadata: {}, succeeded: true)
    record(
      category: "upload",
      action: action,
      message: message,
      metadata: metadata,
      ip_address: request&.remote_ip,
      user_agent: request&.user_agent,
      succeeded: succeeded
    )
  end

  def self.record_slack(action:, message:, metadata: {}, succeeded: true)
    record(
      category: "slack",
      action: action,
      message: message,
      metadata: metadata,
      succeeded: succeeded
    )
  end

  def self.record_ai(action:, message:, metadata: {}, succeeded: true)
    record(
      category: "ai",
      action: action,
      message: message,
      metadata: metadata,
      succeeded: succeeded
    )
  end
end
