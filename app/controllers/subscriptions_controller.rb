class SubscriptionsController < ApplicationController
  before_action :require_login

  def index
    @subscriptions = Current.user.subscribed_events.order(Arel.sql("CASE WHEN events.data_inizio >= CURRENT_DATE THEN 0 ELSE 1 END, events.data_inizio ASC, events.orario_inizio ASC"))
  end
  def create
    @event = Event.find_by(id: params[:id])
    @subscription = @event.subscriptions.build(user: Current.user)

    if @subscription.save
      flash[:notice] = "Iscrizione effettuata con successo!"
    else
      flash[:alert] = @subscription.errors.full_messages.join(', ')
    end
    
    redirect_to events_path
  end

  def destroy
    event = Event.find(params[:id]) 
    Current.user.subscribed_events.destroy(event) 

    redirect_to subscriptions_path, notice: "La tua iscrizione è stata cancellata con successo!"
  end

  private

  def require_login
    unless session[:user_id]
      redirect_to root_path
    end
  end
end
