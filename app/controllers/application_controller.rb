class ApplicationController < ActionController::Base
  before_action :require_login

  private

  DEVELOPMENT_USER_ID     = 1
  DEVELOPMENT_SIGNED_IN   = false
  DEVELOPMENT_USER_IS_MOD = false

  def require_login
    unless signed_in?
      redirect_to signin_index_path(from: request.path)
    end
  end

  def signed_in?
    if Rails.env.production? # Must be on Replit for ReplAuth
      !request.headers["HTTP_X_REPLIT_USER_ID"].blank?
    else
      DEVELOPMENT_SIGNED_IN
    end
  end

  def current_user
    if Rails.env.production?
      @current_user ||= User.find(request.headers["HTTP_X_REPLIT_USER_ID"].to_i) if signed_in?
    else
      @current_user ||= User.find(DEVELOPMENT_USER_ID) if signed_in?
    end
  end

  def current_user_exists?
    return false unless signed_in?

    if Rails.env.production?
      User.exists?(request.headers["HTTP_X_REPLIT_USER_ID"].to_i)
    else
      User.exists?(DEVELOPMENT_USER_ID)
    end
  end
  def current_user_is_mod?
    return false unless signed_in?

    if Rails.env.production?
      request.headers["HTTP_X_REPLIT_USER_ROLES"].split(",").include?("moderator")
    else
      DEVELOPMENT_USER_IS_MOD
    end
  end

  def create_current_user
    raise "Use the repopulated user records for development" if Rails.env.development?

    headers = request.headers

    User.create(
      id:       headers["HTTP_X_REPLIT_USER_ID"].to_i,
      pfp:      headers["HTTP_X_REPLIT_USER_PROFILE_IMAGE"],
      username: headers["HTTP_X_REPLIT_USER_NAME"]
    )
  end
end
