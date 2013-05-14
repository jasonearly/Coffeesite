class UserMailer < ActionMailer::Base
	default :from => "theoffice@gruntmonkey.com"
	def expire_email(user)
		mail(:to => user.email, :subject => "Subscription Cancelled")
	end
end