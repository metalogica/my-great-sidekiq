namespace :user do
  desc "Enriching all users with Clearbit (async)"
  task :update_all => :environment do
    users = User.all
    puts "Enqueuing update of #{users.size} users..."
    users.each do |user|
      UpdateUserJob.perform_later(user.id)
    end
    # rake task will return when all jobs are _enqueued_ (not done).
  end

  desc "Enriching a given user with Clearbit (sync)"
  task :update, [:user_id] => :environment do |t, args|
    user = User.find(args[:user_id])
    puts "Enriching #{user.email}..."
    UpdateUserJob.perform_now(user.id)
    # rake task will return when job is _done_
  end

  desc "hi"
  task :hi => :environment do
    puts "hello"
  end
end