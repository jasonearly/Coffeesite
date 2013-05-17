class UserMailer < ActionMailer::Base
	default :from => "theoffice@gruntmonkey.com"

	def welcome_email(user)
	    @user = user
	    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  	end

	def expire_email(user)
		mail(:to => user.email, :subject => "Subscription Cancelled")
	end



end