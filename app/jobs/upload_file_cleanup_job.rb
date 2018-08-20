class UploadFileCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    deleted = File.delete(args[0])
    puts "Deleted ", deleted
  end
end
