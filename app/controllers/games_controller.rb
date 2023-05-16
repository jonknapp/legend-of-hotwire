class GamesController < ApplicationController
  include ActionView::RecordIdentifier

  # before_action :technical_debt
  before_action :set_game, only: %i[ show destroy ]

  # GET /games
  def index
    @games = Game.all.page(params[:page])

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /games/1
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # POST /games
  def create
    @game = Game.new(game_create_params)

    if @game.save
      Turbo::StreamsChannel.broadcast_prepend_later_to :games, target: 'games', partial: 'games/meta', locals: { game: @game }
      redirect_to @game, notice: "Game was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /games/1
  def destroy
    @game.destroy
    Turbo::StreamsChannel.broadcast_remove_to :games, target: dom_id(@game, :meta)
    redirect_to games_url, notice: "Game was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    def game_create_params
      params.fetch(:sinking_ships_game, {}).permit(:seed)
    end

    def technical_debt
      sleep 5
    end
end
