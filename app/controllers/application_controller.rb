class ApplicationController < ActionController::Base
  include Replit

  before_action :require_login

  private

  DEVELOPMENT_USER_ID     = 2681007
  DEVELOPMENT_SIGNED_IN   = true
  DEVELOPMENT_USER_IS_MOD = true

  def require_login
    redirect_to signin_index_path(from: request.path) unless signed_in?
  end

  def signed_in?
    if Rails.env.production? # Must be on Replit for ReplAuth
      !request.headers['HTTP_X_REPLIT_USER_ID'].blank?
    else
      DEVELOPMENT_SIGNED_IN
    end
  end
  helper_method :signed_in?

  def current_user
    if Rails.env.production?
      if signed_in? && @current_user.nil?
        @current_user = User.find_by(id: request.headers['HTTP_X_REPLIT_USER_ID'].to_i)

        if @current_user.nil?
          @current_user = create_current_user
        else
          # Update username and pfp if they've changed
          pfp      = request.headers['HTTP_X_REPLIT_USER_PROFILE_IMAGE']
          username = request.headers['HTTP_X_REPLIT_USER_NAME']
          @current_user.update(pfp:, username:) if @current_user.pfp != pfp || @current_user.username != username
        end
      end
    elsif signed_in?
      @current_user ||= User.find(DEVELOPMENT_USER_ID)
    end

    @current_user
  end
  helper_method :current_user
  def current_user_is_mod?
    return false unless signed_in?

    if Rails.env.production?
      request.headers['HTTP_X_REPLIT_USER_ROLES'].split(',')
             .any? { |r| %w[moderator administrator admin].include?(r) }
    else
      DEVELOPMENT_USER_IS_MOD
    end
  end
  helper_method :current_user_is_mod?

  def current_user_exists?
    return false unless signed_in?

    if Rails.env.production?
      User.exists?(request.headers['HTTP_X_REPLIT_USER_ID'].to_i)
    else
      User.exists?(DEVELOPMENT_USER_ID)
    end
  end

  def create_current_user
    raise 'Use the repopulated user records for development' if Rails.env.development?

    headers = request.headers

    id       = headers['HTTP_X_REPLIT_USER_ID'].to_i
    pfp      = headers['HTTP_X_REPLIT_USER_PROFILE_IMAGE']
    username = headers['HTTP_X_REPLIT_USER_NAME']

    pfp = Client.new.get_user_pfp(id) if pfp.blank?

    User.create!(
      id:       id,
      pfp:      pfp,
      username: username
    )
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
