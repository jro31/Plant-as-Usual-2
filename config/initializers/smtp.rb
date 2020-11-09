ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'plantasusual.com',
  user_name: ENV['GMAIL_USER_NAME'],
  password: ENV['GMAIL_PASSWORD'],
  authentication: :plain,
  enable_starttls_auto: true
}
