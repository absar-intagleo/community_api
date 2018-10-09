class ApplicationController < ActionController::API

	before_action :validate_api_key

	protected
	def validate_token
		 @error_message = []
		if request.headers['Authorization'].present?
      if !request.headers['Authorization'].include?("Token ") || request.headers['Authorization'].split(" ").present? && !(request.headers['Authorization'].split(" ").count > 1)
        @error_message << "Invalid Authorization token"
      else  
        @current_user = User.find_by_community_token(request.headers['Authorization'].split(" ")[1])    
        if @current_user.blank?
          @error_message << "Invalid Authorization token"
        end
      end
    else
      @error_message << "Authorization header must be present."
    end

    if @error_message.present?
    	render(json: {ok: false, error: @error_message, status: 401}, status: 401) and return
    end
	end

	private
	def validate_api_key
		# unless params["apiKey"].present? || ActiveSupport::SecurityUtils.secure_compare(ENV['API_KEY'],params["apiKey"])
  #     response = params["apiKey"].present? ? {"error": "Invalid Authentication" } : {"error": "Missing parameter: ApiKey" } 
		# 	render(json: response.to_json, status: 401) and return
		# end
	end

end
