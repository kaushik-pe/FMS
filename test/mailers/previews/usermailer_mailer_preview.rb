# Preview all emails at http://localhost:3000/rails/mailers/usermailer_mailer
class UsermailerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/usermailer_mailer/ticket
  def ticket
    UsermailerMailer.ticket
  end

  # Preview this email at http://localhost:3000/rails/mailers/usermailer_mailer/brochure
  def brochure
    UsermailerMailer.brochure
  end

end
