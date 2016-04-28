require 'rails_helper'

RSpec.describe SendNewArgumentNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:link) { FactoryGirl.create(:statement_argument_link) }

  subject(:job) { described_class.perform_later(link) }

  it "queues the job" do
    pending "Get this test to work when a queueing back-end is available"
    expect(job).to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it "is in default queue" do
    expect(described_class.new.queue_name).to eq("default")
  end

  it "executes perform" do
    expect(StatementMailer).to receive(:new_argument_email)
    perform_enqueued_jobs { job }
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
