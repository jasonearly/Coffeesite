class User < ActiveRecord::Base
	rolify
# Include default devise modules. Others available are:
# :token_authenticatable, :confirmable,
# :lockable, :timeoutable and :omniauthable
devise :database_authenticatable, :registerable,
:recoverable, :rememberable, :trackable, :validatable
# Setup accessible (or protected) attributes for your model
attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :stripe_token, :coupon
attr_accessor :stripe_token, :coupon
before_save :update_stripe
def update_stripe
	return if email.include?(ENV['ADMIN_EMAIL'])
	return if email.include?('@example.com') and not Rails.env.production?
	if customer_id.nil?
		if !stripe_token.present?
			raise "Stripe token not present. Can't create account."
		end
		if coupon.blank?
			customer = Stripe::Customer.create(
				:email => email,
				:description => name,
				:card => stripe_token,
				:plan => roles.first.name
				)
		else
			customer = Stripe::Customer.create(
				:email => email,
				:description => name,
				:card => stripe_token,
				:plan => roles.first.name,
				:coupon => coupon
				)
		end
	else
		customer = Stripe::Customer.retrieve(customer_id)
		if stripe_token.present?
			customer.card = stripe_token
		end
		customer.email = email
		customer.description = name
		customer.save
	end
	self.last_4_digits = customer.active_card.last4
	self.customer_id = customer.id
	self.stripe_token = nil
rescue Stripe::StripeError => e
	logger.error "Stripe Error: " + e.message
	errors.add :base, "#{e.message}."
	self.stripe_token = nil
	false
end
end