class BansController < ApplicationController
  before_action :check_is_mod, except: :banned
  skip_before_action :check_banned, only: :banned

  def index
    @bans = User.banned
  end

  def create
    @user = User.where("LOWER(username) = ?", params[:username].downcase).first

    if @user.nil?
      @bans = User.banned

      flash.now[:alert] = 'User not found!'
      render :index, status: :unprocessable_entity
    else
      @user.update(banned: true)

      flash[:notice] = 'User banned!'
      redirect_to bans_path
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])

    if @user.nil?
      @bans = User.banned

      flash.now[:alert] = 'User not found!'
      render :index, status: :unprocessable_entity
    else
      @user.update(banned: false)

      flash[:notice] = 'User unbanned!'
      redirect_to bans_path
    end
  end

  def banned
    unless current_user.banned?
      if current_user_is_mod?
        redirect_to bans_path
      else
        redirect_to tickets_path
      end
    end
  end

  private

  def check_is_mod
    not_found unless current_user_is_mod?
  end
end
