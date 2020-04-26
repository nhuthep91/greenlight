class SsoController < ApplicationController
    include Authenticator

    skip_before_action :set_user_settings, :maintenance_mode?, :migration_error?,
    :user_locale, :check_admin_password, :check_user_role
    # GET /health_check
    def access
	require 'open-uri'
	require 'json'
	request_url = "https://atmlucky.com/api/auth/code?"
	token = "code=" + params[:access_token]
	url = "#{request_url}#{token}"
    data = URI.parse(url).read
    json = JSON.parse(data)
    user = json["data"]["user"];
    #TrinhNX: updating data with following information
    #provider: account from atmlucky
    #social_uid: the id from atmlucky
    #email and name is from atmlucky
    #username has same value vs name
    #pwd random (min 6 character)
    #Check user exist
    # TODO: Migrate to add point columns
    # TODO: Exception then gonna redirect to : see redirect_to
    # Reuse method from user model
    auth = {}
    auth['info']={}
    logger.info "Support: User #{user} is attempting to login."
    auth['provider'] = 'atmlucky'
    auth['uid'] = user['id']
    authInfo = auth['info']
    authInfo['name'] = user["name"]
    authInfo['nickname'] = user["name"]
    authInfo['email'] = user["email"]
    authInfo['image'] = user['avatar']
    point = user["point"]
    # Add auth infor (for auth_values)
    logger.info "Support: authInfo user #{auth} is attempting to login."
    user = User.from_omniauth(auth)
    logger.info "Support: User from omniauth #{user} is attempting to login."
    login(user)
    logger.info "Support: #{user.email} user has been logged."
    end
end
