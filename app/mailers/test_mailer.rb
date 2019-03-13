class TestMailer < ActionMailer::Base
  def message
    # mail(
    #   :subject => 'Hello from Postmark',
    #   :to  => 'sherly@hartono.info',
    #   :from => 'admin@sijibills.com',
    #   :html_body => '<strong>Hello</strong> dear Postmark user.',
    #   :track_opens => 'true')
  end
end
