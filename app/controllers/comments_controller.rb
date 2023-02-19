class CommentsController < ApplicationController
  before_action :populate_ticket

  def index
    @comments = @ticket.comments.includes(:user)
    @new_comment = @ticket.comments.build
  end

  def create
    @new_comment = @ticket.comments.new(new_comment_params)
    @new_comment.user_id = current_user.id
    @new_comment.moderator = current_user_is_mod?

    if @new_comment.save
      flash[:notice] = 'Comment created!'
      redirect_to ticket_comments_path(@ticket.id)
    else
      @comments = @ticket.comments
      flash.now[:alert] = 'Invalid comment!'
      render :index, status: :unprocessable_entity
    end
  end

  private

  def populate_ticket
    @ticket = Ticket.find(params[:ticket_id])
    not_found if @ticket.nil? || !(current_user_is_mod? || @ticket.user.id == current_user.id)
  end

  def new_comment_params
    params.require(:comment).permit(:content)
  end
end
