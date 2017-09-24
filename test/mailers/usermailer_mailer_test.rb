require 'test_helper'

class UsermailerMailerTest < ActionMailer::TestCase
  test "ticket" do
    mail = UsermailerMailer.ticket
    assert_equal "Ticket", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "brochure" do
    mail = UsermailerMailer.brochure
    assert_equal "Brochure", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
