require "test_helper"

class ActivityLogTest < ActiveSupport::TestCase
  test "record_upload stores ip address and user agent" do
    request = Struct.new(:remote_ip, :user_agent).new("203.0.113.4", "ExampleBrowser/2.0")

    assert_difference -> { LogEntry.count }, 1 do
      ActivityLog.record_upload(
        action: "preview_photo",
        message: "Uploaded preview photo",
        request: request,
        metadata: { blob_key: "xyz" }
      )
    end

    entry = LogEntry.order(:id).last
    assert_equal "upload", entry.category
    assert_equal "203.0.113.4", entry.ip_address
    assert_equal "ExampleBrowser/2.0", entry.user_agent
  end
end
