class TicketsController < ApplicationController
  before_action :does_ticket_exist, only: [:show, :update]
  before_action :can_view_ticket, only: :show
  before_action :can_update_ticket, only: :update
  before_action :populate_types_and_status, only: [:new, :create]

  def index
    @tickets = (current_user_is_mod? ? Ticket.all : current_user.tickets)
                 .where(status_id: filters)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .left_joins(:comments)
                 .select("tickets.*, COUNT(comments.id) AS comment_count")
                 .group("tickets.id")
    @status_types = Status.all
  end

  def new
    @ticket = current_user.tickets.build
  end
  def create
    @ticket = current_user.tickets.new(new_ticket_params)
    @ticket.status_id = Status.find_by(name: 'incomplete').id

    if @ticket.save
      flash[:notice] = 'Ticket created!'
      redirect_to @ticket
    else
      flash.now[:alert] = 'Invalid ticket!'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @ticket = Ticket.find_by(id: params[:id]) || not_found
    @status_types = Status.all
  end

  def update
    @ticket = Ticket.find_by(id: params[:id]) || not_found
    if @ticket.update(update_params)
      flash[:notice] = 'Status updated!'
      redirect_to @ticket
    else
      @ticket = Ticket.find(params[:id])
      @status_types = Status.all
      flash.now[:alert] = 'Invalid status!'
      render :show, status: :unprocessable_entity
    end
  end

  private

  def filters
    return Status.all.map(&:id) if params.nil? || !params.include?(:filters)
    params.require(:filters).permit(statuses: [])[:statuses]
  end

  def new_ticket_params
    params.require(:ticket).permit(:type_id, :content)
  end

  def update_params
    params.require(:ticket).permit(:status_id)
  end

  def does_ticket_exist
    @ticket = Ticket.find_by(id: params[:id]) || not_found
  end

  def can_view_ticket
    not_found unless current_user_is_mod? || Ticket.find(params[:id]).user.id == current_user.id
  end

  def can_update_ticket
    not_found unless current_user_is_mod?
  end

  def populate_types_and_status
    @appeal_types = Type.all
    @default_type = @appeal_types.find_by(name: 'warn')
  end
end
