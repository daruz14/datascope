class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /events or /events.json
  def index
    @events = current_user.company ? Event.in_same_company_as(current_user) : current+user.events
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @user = current_user
    @colleagues = @user.company.users.where.not(id: @user.id)
  end

  # GET /events/1/edit
  def edit
    @user = current_user
    @colleagues = @user.company.users.where.not(id: @user.id)
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :start_date, :end_date, user_ids: [])
        .tap do |event_params|
        if current_user && !event_params[:user_ids].include?(current_user.id)
          event_params[:user_ids] << current_user.id
        end
      end
    end
end
