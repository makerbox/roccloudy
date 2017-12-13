class RegistrationsController < Devise::RegistrationsController
	protected

	def after_sign_up_path_for(resource)
		:new_account
	end

	def after_update_path_for(resource)
      redirect_to 'http://218.214.78.21:3200?' + resource.email
    end
end