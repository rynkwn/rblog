desc "Task called by the Heroku scheduler add-on to send out Daily Messenger emails."
task :test => :environment do
  puts "Updating feed..."
  ServiceMailer::email("test", "rynkwn@gmail.com", "test")
  puts "done."
end