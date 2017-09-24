class UsermailerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.usermailer_mailer.ticket.subject
  #
  def ticket(user,path,filename)
    @user = user
    attachments[filename] = File.read(path)
    mail(to: @user.emailid, subject: 'Ticket:-)')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.usermailer_mailer.brochure.subject
  #
  def brochure(user,path,filename)
    @user = user
    attachments[filename] = File.read(path)
    mail(to: @user.emailid, subject: 'Ticket:-)')
  end
end
