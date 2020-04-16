class SSOController < ApplicationController
    # GET /health_check
    def signin
        response = "Hello world"
        render plain: response
  end
end