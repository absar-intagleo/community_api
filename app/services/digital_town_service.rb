class DigitalTownService

  attr_accessor :register_url, :login_url

  APIENDPOINTS = {
    'register' => 'api/users',
    'token' => '/oauth/token',
    'login' => 'ajax-login',
    'details' => '/api/users',
    'profile' => '/api/profile',
    'profile_image' => '/api/images/save',
    'community_login' => '/api/v1/auth-dt/token-login/',
    'forgot' => '/api/password/email',
    'google' => "/login/google?callbacksocial=",
    'facebook' => "/login/facebook?callbacksocial=",
    'linkedin' => "/login/linkedin?callbacksocial=",
    'logout' => "/ssologout/?callback="
  }

  APIBASEURLS =  {
    "login_url" => ENV['SSO_LOGIN_URL'],
    "profile_url" => ENV['SSO_PROFILE_URL'],
    "community_url" => ENV['SSO_COMMUNITY_URL']
  }

  def registerUser(user_info)
    apiCallURL(APIBASEURLS['login_url'] + APIENDPOINTS['register'], user_info, "POST")
  end
  
  def loginUser(login_params)
    user_info = {
      "email" => login_params[:email],
      "password" => login_params[:password]
    }
    token = apiCallURL(APIBASEURLS['login_url'] + APIENDPOINTS['login'], user_info, "POST")
    if token["error"].present?
      token.merge!(:status => 404)
      return token
    elsif token["accessToken"] 
      user = userDetail(token["accessToken"])
      session = {
        "access_token" => token['accessToken'],
        "user_id" => user['id'],
        "uuid" => user['uuid']
      }
      profile = userProfile(session)
      community_login_res = userCommunityLogin({access_token: token["accessToken"]})
      update_user(token, profile, community_login_res)
      user.merge!(:profile => profile, :access_token => token["accessToken"], :refresh_token => token["refreshToken"], community: community_login_res)
    end
  end

  def userDetail(token)
    header = {}
    header[:authorization] = "Bearer #{token}"
    apiCallURL(APIBASEURLS['login_url'] + APIENDPOINTS['details'], nil, "GET", header)
  end

  def userProfile(session)
    header = {}
    header[:authorization] = "Bearer #{session['access_token']}"
    apiCallURL(APIBASEURLS['profile_url'] + APIENDPOINTS['profile'] + "?userID=#{session['user_id']}", nil, "GET", header)
  end

  def userCommunityLogin(param)
    header = {}
    header["Content-Type"] = "application/x-www-form-urlencoded"
    apiCallURL(APIBASEURLS['community_url'] + APIENDPOINTS['community_login'], param, "POST", header)
  end

  def update_user(token, profile, community_login_res)
    @user = User.find_by_email(profile['data']['profile']['email'])
    if @user.present? 
      @user.update_attributes(
        uuid: profile['data']['profile']['profileUserUUID'],
        first_name: profile['data']['profile']['profileFirstName'],
        last_name: profile['data']['profile']['profileLastName'],
        email: profile['data']['profile']['email'],      
        phone_number:  profile['data']['phone'].present? ? profile['data']['phone']['contactPhoneNumber'] : "",
        absolute_url: nil,
        avatar: profile['data']['images'][0].present? ? profile['data']['images'][0]['imageURL'] : "",
        avatar_thumbnail: nil,
        access_token: token["accessToken"],
        token_created_at: DateTime.now,
        community_token: community_login_res["token"],
        community_id: community_login_res["last_active_community"].present? && community_login_res["last_active_community"]["id"].present? ? community_login_res["last_active_community"]["id"] : ""
      )
    else
      @user = User.new(
        uuid: profile['data']['profile']['profileUserUUID'],
        first_name: profile['data']['profile']['profileFirstName'],
        last_name: profile['data']['profile']['profileLastName'],
        email: profile['data']['profile']['email'],      
        phone_number:  profile['data']['phone'].present? ? profile['data']['phone']['contactPhoneNumber'] : "",
        absolute_url: nil,
        avatar: profile['data']['images'][0].present? ? profile['data']['images'][0]['imageURL'] : "",
        avatar_thumbnail: nil,
        access_token: token["accessToken"],
        token_created_at: DateTime.now,
        community_token: community_login_res["token"],
        community_id: community_login_res["last_active_community"].present? && community_login_res["last_active_community"]["id"].present? ? community_login_res["last_active_community"]["id"] : ""
      )
      @user.save!
    end
    @user
  end

  def forgotPassword(email)
    reset_password = {
        "email" => email
    }
    apiCallURL(APIBASEURLS['login_url'] + APIENDPOINTS['forgot'], reset_password, "POST")
  end

  def socialLogin(access_token) 
  end

  def googleLogin()
    APIBASEURLS['login_url']+ APIENDPOINTS['google'] + ENV['DOMAIN_NAME'] +'/users/social_login'
  end

  def facebookLogin()
    APIBASEURLS['login_url']+ APIENDPOINTS['facebook'] + ENV['DOMAIN_NAME']  + '/users/social_login'
  end

  def linkedinLogin()
    APIBASEURLS['login_url']+ APIENDPOINTS['linkedin'] + ENV['DOMAIN_NAME']  + '/users/social_login' 
  end

  def userLogout()
    APIBASEURLS['login_url'] + APIENDPOINTS['logout'] + ENV['DOMAIN_NAME']  + '/users/logout'
  end

  def apiCallURL(url, params, request_type, headers={ 'Content-Type' => 'application/json' })
    @result = if request_type.eql?("POST")
      HTTParty.post(url, :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } )
    else
      headers.merge!('Content-Type' => 'application/json', 'Accept' => 'application/json')
      HTTParty.get(url, headers: headers)
    end
    JSON.parse(@result.read_body)
  end
end