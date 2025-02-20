class TicketsController < ApplicationController
  before_action :does_ticket_exist, only: %i[show update]
  before_action :can_view_ticket, only: :show
  before_action :can_update_ticket, only: :update
  before_action :populate_types_and_status, only: %i[new create]

  def index
    @tickets = (current_user_is_mod? ? Ticket.all : current_user.tickets)
               .where(status: filters)
               .includes(:user)
               .order(created_at: :desc)
               .page(params[:page])
    @status_types = Ticket.statuses_list
  end

  def new
    @ticket = current_user.tickets.build
  end

  def create
    @ticket = current_user.tickets.new(new_ticket_params)

    if @ticket.save
      flash[:notice] = 'Ticket created!'
      redirect_to @ticket
    else
      flash.now[:alert] = 'Invalid ticket!'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @status_types = Ticket.statuses_list
  end

  def update
    if @ticket.update(update_params)
      flash[:notice] = 'Status updated!'
      redirect_to @ticket
    else
      @ticket = Ticket.find(params[:id])
      @status_types = Ticket.statuses_list
      flash.now[:alert] = 'Invalid status!'
      render :show, status: :unprocessable_entity
    end
  end

  private

  def filters
    return Ticket.statuses_list if params.nil? || !params.include?(:filters)

    params.require(:filters).permit(statuses: [])[:statuses]
  end

  def new_ticket_params
    pa = params.require(:ticket).permit(:appeal_type, :content)
    pa[:appeal_type] = Ticket.unformat_ticket_type(pa[:appeal_type])
    pa
  end

  def update_params
    params.require(:ticket).permit(:status)
  end

  def does_ticket_exist
    @ticket = Ticket.find_by(id: params[:id]) || not_found
  end

  def can_view_ticket
    not_found unless current_user_is_mod? || @ticket.user.id == current_user.id
  end

  def can_update_ticket
    not_found unless current_user_is_mod?
  end

  def populate_types_and_status
    @appeal_types = Ticket.appeal_types_list.reject { |t| t == 'report' }
    @default_type = @appeal_types[0]
  end
end
