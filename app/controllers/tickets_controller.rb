class TicketsController < ApplicationController
  def index
    @tickets = (current_user_is_mod? ? current_user.tickets : Ticket.all).order(:created_at).page(params[:page])
  end
end
