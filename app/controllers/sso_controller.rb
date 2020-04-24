class SsoController < ApplicationController
    skip_before_action :set_user_settings, :maintenance_mode?, :migration_error?,
    :user_locale, :check_admin_password, :check_user_role
    # GET /health_check
    def access
	require 'open-uri'
	require 'json'
	request_url = "https://atmlucky.com/api/auth/code?"
	token = "code=" + params[:access_token]
	url = "#{request_url}#{token}"
    @data = URI.parse(url).read
    @json = JSON.parse(@data)
    @user = @json["data"]["user"];
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
    @auth = {}
    @auth['provider'] = 'atmlucky'
    @auth['uid'] = @user['id']
    @auth['name'] = @user["name"]
    @auth['username'] = @user["name"]
    @auth['email'] = @user["email"]
    @point = @user["point"]
    user = User.from_omniauth(@auth)
    logger.info "Support: Auth user #{user.email} is attempting to login."
    login(user)
    logger.info "Support: #{@user.email} user has been logged."
    redirect_to root_path
    # render plain: @user_domain
    end
end
