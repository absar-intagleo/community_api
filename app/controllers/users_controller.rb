class UsersController < ApplicationController

	before_action :validate_login_params, only: :login
  before_action :validate_create_params, only: :create
  before_action :validate_members_params, only: :members
  before_action :downcase_email, only: [:login, :create]
  before_action :validate_token, only: :members

	def create
		# @response = Rails.env.development? ? {"ok"=>true, "data"=>{"id"=>9066, "uuid"=>"b006cd54-b4c4-11e8-bf87-06b9b6fd22b8", "first_name"=>"test", "last_name"=>"test123", "email"=>"testascinasg@rezserve.com", "active"=>1, "details"=>{"email"=>"testing@rezserve.com", "method"=>"UsersController.create", "last_name"=>"test123", "first_name"=>"test"}, "remember_token"=>nil, "verified"=>false, "verification_token"=>"25b64bdc7a0bb710b51de28fb5a485703c3741c59ca1769d33696e342c17f456", "created_at"=>"2018-09-10 06:42:29", "updated_at"=>"2018-09-10 06:42:30", "message"=>"You will receive an email with instructions about how to confirm your account in a few minutes. If you don't receive please check your spam mailbox or <a href='https://v1-sso-api.digitaltown.com/email-verification/send/testing%40rezserve.com?callback=https://account.digitaltown.com/profile'>click here to resend the email. </a>", "profile"=>{"ok"=>true, "user"=>{"profile"=>{"profileID"=>8953, "profileUserID"=>9066, "profileRelationID"=>8953, "profileType"=>1, "profileFirstName"=>"test", "profileLastName"=>"test123", "profileActive"=>1, "profileCreated"=>"", "profileUpdated"=>"", "profileAbout"=>"", "profileInterests"=>"", "profileFacebook"=>"", "profileInstagram"=>"", "profileTwitter"=>"", "profileLinkedin"=>"", "url_hash"=>"aphzh8", "verification"=>{}, "profileCityID"=>"", "profileOptOutMarketing"=>0, "profileUserUUID"=>"b006cd54-b4c4-11e8-bf87-06b9b6fd22b8", "profileAcceptTermsConditions"=>0, "email"=>"testing@rezserve.com", "invites"=>[]}, "contact"=>{"contactID"=>9066, "contactSSOID"=>8953, "contactProfileID"=>"b006cd54-b4c4-11e8-bf87-06b9b6fd22b8", "contactFirstName"=>"test", "contactLastName"=>"test123", "contactPrimary"=>"1", "contactPermissions"=>"", "contactActive"=>"1", "contactCreated"=>"", "contactUpdated"=>""}, "address"=>nil, "email"=>{"contactEmailID"=>8880, "contactEmailRelationID"=>8880, "contactEmailAddress"=>"testing@rezserve.com", "contactEmailPrimary"=>1, "contactEmailActive"=>"1", "contactEmailCreated"=>"", "contactEmailUpdated"=>""}, "phone"=>nil, "images"=>[nil]}}}, "accessToken"=>"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImJmZWM5YzBjN2JjOWJhMDkxNWE4MjEyNzM1ZTkzZmU4MjJjYjY0Y2M0ZGJiNmY1N2Y0ZmU4YTE5YzBmM2Y5NWY4NmRlMDUzM2NjNjY5YTcxIn0.eyJhdWQiOiIxMTkiLCJqdGkiOiJiZmVjOWMwYzdiYzliYTA5MTVhODIxMjczNWU5M2ZlODIyY2I2NGNjNGRiYjZmNTdmNGZlOGExOWMwZjNmOTVmODZkZTA1MzNjYzY2OWE3MSIsImlhdCI6MTUzNjU2MTc0OSwibmJmIjoxNTM2NTYxNzQ5LCJleHAiOjE1NDUyMDE3NDksInN1YiI6IjkwNjYiLCJzY29wZXMiOlsiSUQiLCJlbWFpbCIsInByb2ZpbGUiLCJidXNpbmVzcyIsImF2YXRhciJdfQ.Bhq42ONvthGLDeH8QW0PwubA-O9IqpoZq4Jiipog6cw8Yj3bpJnGX9sWIkvfr-HpMizPFe9MxrgxUqZTr2kybk4vVdLvXd5aeb3pG3FqanOArGrYoOG8E7gvdDyZF9XY7Waup6HVt3fAsL_yQ3F1QD-5uUg0yu-iBJxkVTgkRv5zONJCPUG-s7d-nRYPMvLB8IoIaqyt4-l3Nk-Iu0n6bnplAxNzw-WEjfsPHg4TKKhV0elKEef1uQATt0iQUecpIHEWn2x0SQCiSI8H8Uti32tcKcWiZeNN45cXaq2RDxbiVYh17rksR_ktQaz5LwjrGi758_nDy7UqjZMN1nza5ke8B-ddPmaDitLP8y2zhwE-YYtQiudKjnsgbn_2c9XkqtzHt7x00R1cu9yXXu2RMZwPvat_ck-2JrV5ZSxc3IPaXEatJcmZsqUMSzsdu9_5URZr1XurnUvgWWlyUiQm8Lw1aeBTAvNbJaUoXnu0a2By7h_v6HY5A8jh6z_jmrLsCQ9Iurv90Tkn6orkkI6e5OcUPhsJTVdqk-BZ5SmqH0C58xddvK2w8Q9Z_TenrfVNaW2Hmzl7xECIjcrxnjzccuzstqb6Ct0QFPE8eC3P314J0UJICDOgRPMNplIbC7DSZtq1JbZI2UOgh8J-vPEEYFuQ-SCtPLt4gjMIhF-lc58"} : DigitalTownService.new.registerUser(params.slice!(:first_name, :last_name, :email, :password, :phone, :profileCityID))
    @response = DigitalTownService.new.registerUser(params.slice!(:first_name, :last_name, :email, :password, :phone, :profileCityID))
    if @response["error"].blank?
      user = User.find_by_email(@response['data']["email"])
      if user.blank?
        @user = User.new(
          first_name: @response['data']["first_name"],
          last_name: @response['data']["last_name"],
          email: @response['data']["email"].downcase,
          phone_number: @response['data']["details"]["phone"],
          uuid: @response['data']["uuid"],
          access_token: @response["accessToken"]
        )
        
        if @user.save
        	render json: @response
        else
          render json: @response
        end
      end      
    else
      @response["error"] = @response["error"].map{|c| c[1]}.try(:flatten) if @response["error"].present?
      render(json: @response, status: 401)
    end
	end

	def members
    @users = if params[:slug_name].present?
      # .with_same_community(@current_user.community_id)
      User.except_current_user(@current_user.id).where("lower(first_name) like ? OR lower(last_name) like ?", "%#{params[:slug_name]}%", "%#{params[:slug_name].downcase}%")
    elsif params[:email].present?
      User.except_current_user(@current_user.id).where("email like ?", "%#{params[:email].downcase}%")
    end
    render(json: {ok: true, count: @users.count, results: @users, status: 200}, status: 200)   
	end

	def login
		response = DigitalTownService.new.loginUser(params.slice!(:email, :password))
    if response[:status] == 404
      render json: response, status: 404
    else
      user = User.find_by_email(params[:email])
  		render json: response.merge!(community_membership_id: user.id)
    end
	end

	def logout
	end

	private

  def downcase_email
    params[:email].downcase!
  end

	def validate_login_params
		@error_message = []
    @error_message << "Email must be present." if !params[:email].present?
    @error_message << "Password must be present." if !params[:password].present?
    if @error_message.present?
  		render(json: {ok: false, error: @error_message}, status: 401) and return
  	end
	end

  def validate_create_params
    @error_message = []
    @error_message << "Email must be present." if !params[:email].present?
    @error_message << "Password must be present." if !params[:password].present?
    @error_message << "first_name must be present." if !params[:first_name].present?
    @error_message << "last_name must be present." if !params[:last_name].present?
    @error_message << "profileCityID must be present." if !params[:profileCityID].present?
    if @error_message.present?
      render(json: {ok: false, error: @error_message, status: 401}, status: 401) and return
    end
  end

  def validate_members_params
    @error_message = []
    @error_message << "'email' or 'slug_name' must be present." if !params[:email].present? && !params[:slug_name].present?
    if @error_message.present?
      render(json: {ok: false, error: @error_message, status: 401}, status: 401) and return
    end
  end
end
