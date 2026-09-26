require "test_helper"

class DescribeItemJobTest < ActiveJob::TestCase
  setup do
    @item = Item.create!(description: "Label printer")
    @item.photo.attach(
      io: StringIO.new(Vips::Image.black(10, 10).jpegsave_buffer),
      filename: "photo.jpg",
      content_type: "image/jpeg"
    )
  end

  test "stores the AI description and enqueues the duplicate check" do
    with_described_image("A Brother label printer") do
      DescribeItemJob.perform_now(@item.id)
    end

    assert_equal "A Brother label printer", @item.reload.ai_description
    assert_enqueued_with(job: CheckDuplicatesJob, args: [ @item.id ])
  end

  test "does not enqueue the duplicate check when AI is disabled" do
    AgentSetting.instance.update!(enabled: false)

    DescribeItemJob.perform_now(@item.id)

    assert_no_enqueued_jobs(only: CheckDuplicatesJob)
  end

  private

  def with_described_image(text)
    AgentSetting.instance.update!(enabled: true)
    original = OllamaService.instance_method(:describe_image)
    OllamaService.define_method(:describe_image) { |_photo| text }
    yield
  ensure
    OllamaService.define_method(:describe_image, original)
  end
end
