require 'rails_helper'

RSpec.describe RecalculateStatementScoresJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later() }

  it "queues the job" do
    pending "Get this test to work when a queueing back-end is available"
    expect(job).to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it "is in default queue" do
    expect(described_class.new.queue_name).to eq("default")
  end

  it "executes perform" do
    expect(StatementTreeScoreUpdater).to receive(:update_all)
    perform_enqueued_jobs { job }
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
