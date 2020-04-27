class SsoController < ApplicationController
	include Authenticator
        
    skip_before_action :set_user_settings, :maintenance_mode?, :migration_error?, :user_locale, :check_admin_password, :check_user_role
    # Auth from token
    def access
		require 'open-uri'
		require 'json'
		request_url = "https://atmlucky.com/api/auth/code?"
        token = "code=" + params[:access_token]
        url = "#{request_url}#{token}"
        begin
            data = URI.parse(url).read
            json = JSON.parse(data)
            user = json["data"]["user"];
            # TODO: Migrate to add point columns
            auth = {}
            auth['info']={}
            auth['provider'] = 'atmlucky'
            auth['uid'] = user['id']
            authInfo = auth['info']
            authInfo['name'] = user["name"]
            authInfo['nickname'] = user["name"]
            authInfo['email'] = user["email"]
            authInfo['image'] = user['avatar']
            point = user["point"]
            @user_exists = check_user_exists(auth['uid'], auth['provider'])
            logger.info "Support: authInfo user #{auth} is attempting to login. #{@user_exists}"
            if(@user_exists)
                user = User.from_omniauth(auth)
                logger.info "Support: User from omniauth #{user} is attempting to login."
                login(user)
                logger.info "Support: #{user.email} user has been logged."
            else
                redirect_to signin_path
            end
        rescue Exception => e
            logger.info "Exception #{e.backtrace}"
            redirect_to signin_path
        end
    end
    
    def check_user_exists(s_uid, provider_name)
		User.exists?(social_uid: s_uid, provider: provider_name)
	end
end
