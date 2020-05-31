class SsoController < ApplicationController
	include Authenticator
        
    skip_before_action :set_user_settings, :maintenance_mode?, :migration_error?, :user_locale, :check_admin_password, :check_user_role
    # Auth from token
    def access
		require 'openssl'
		require 'open-uri'
		require 'json'
		request_url = "https://atmlucky.com/api/auth/code?"
        token = "code=" + params[:access_token]
        url = "#{request_url}#{token}"
	logger.info "url: #{url}"
        begin
	    request_uri=URI.parse(url)
	    output=open(request_uri, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
            data = output.read
            json = JSON.parse(data)
            if json.key?("errors")
		logger.info "Fail: #{json}"
                raise Exception.new('Invalid token')
            end
            user = json["data"]["user"];
            # TODO: Migrate to add point columns
            auth = User.from_atmluckyauth(user)
            logger.info "Support: authInfo user #{auth} is attempting to login."
            user = User.from_omniauth(auth)
            login(user)
            logger.info "Support: #{user.email} user has been logged."
        rescue Exception => e
            logger.info "Exception #{e.backtrace}"
            redirect_to(signin_path, alert: I18n.t("invalid_credentials"))
        end
    end
end
