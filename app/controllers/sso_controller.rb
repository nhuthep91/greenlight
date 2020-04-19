class SsoController < ApplicationController
    skip_before_action :redirect_to_https, :set_user_domain, :set_user_settings, :maintenance_mode?, :migration_error?,
    :user_locale, :check_admin_password, :check_user_role
    # GET /health_check
    def access
	require 'open-uri'
	require 'json'
	request_url = "https://atmlucky.com/api/auth/code?"
	token = "code=" + params[:access_token]
	url = "#{request_url}#{token}"
#	buffer = open(url).read
	@data = URI.parse(url).read
        render plain: @data
    end
end
