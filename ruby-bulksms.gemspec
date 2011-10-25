Gem::Specification.new do |s|
  s.name     = "ruby-bulksms"
  s.version  = "0.4.1"
  s.date     = "2011-10-25"
  s.summary  = "Sending SMS using bulksms services"
  s.email    = "info@shuntyard.co.za"
  s.homepage = "http://github.com/basayel/ruby-bulksms"
  s.description = "Integrating SMS services into RubyOnRails applications using BulkSMS gateway"
  s.has_rdoc = true
  s.authors  = ["Basayel Said", "Shuntyard Technologies"]
  s.files    = [ 
                "ruby-bulksms.gemspec", 
                "README.rdoc",
                "lib/ruby-bulksms.rb",
                "lib/net/sms/bulksms/bulk_sms_account.rb",
                "lib/net/sms/bulksms/message.rb",
                "lib/net/sms/bulksms/response.rb",
                "lib/net/sms/bulksms.rb"
  ]
end
