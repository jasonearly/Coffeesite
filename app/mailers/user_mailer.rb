class UserMailer < ActionMailer::Base
	default :from => "theoffice@gruntmonkey.com"

	def welcome_email(user)
	    @user = user
	    mail(:to => user.email, :subject => "Registered")
  	end

	def expire_email(user)
		@user = user
		mail(:to => user.email, :subject => "Subscription Cancelled")
	end



end