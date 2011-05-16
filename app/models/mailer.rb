class Mailer < ActionMailer::Base
  def new_headline_notification(user, headline)
     recipients user.email
     from       "news@kitsaphauntedfairgrounds.com"
     subject    "KHF: New HEADline Posted"
     body       (:user => user, :headline => headline)
  end
end
