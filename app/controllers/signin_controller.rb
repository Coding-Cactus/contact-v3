class SigninController < ApplicationController
  skip_before_action :require_login

  def index
    if signed_in?
      create_current_user unless current_user_exists?

      redirect_to params[:from].nil? ? tickets_path : from
    end
  end
end
