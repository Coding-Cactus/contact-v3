class CommentsController < ApplicationController
  before_action :populate_ticket, except: %i[show edit update]
  before_action :check_edit_perms, only: %i[show edit update]

  def index
    @comments = @ticket.comments.includes(:user).order(created_at: :asc)
    @new_comment = @ticket.comments.build
  end

  def create
    @new_comment = @ticket.comments.new(comment_params)
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

  def show; end
  def edit; end

  def update
    if @comment.update(comment_params)
      flash[:comment_edit] = 'Comment updated!'
      redirect_to ticket_comment_path(@comment.ticket_id, @comment.id)
    else
      flash.now[:alert] = 'Invalid comment!'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def populate_ticket
    @ticket = Ticket.find(params[:ticket_id])
    not_found if @ticket.nil? || !(current_user_is_mod? || @ticket.user_id == current_user.id)
  end

  def check_edit_perms
    @comment = Comment.find(params[:id])
    not_found if @comment.nil? || !(current_user_is_mod? && @comment.user_id == current_user.id)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
