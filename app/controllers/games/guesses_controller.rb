module Games
  class GuessesController < ApplicationController
    include ActionView::RecordIdentifier

    def create
      game = Game.find(params[:game_id])
      value = game.board[params['row'].to_i][params['column'].to_i]
      miss = value == Game::EMPTY_SPACE

      game.board[params['row'].to_i][params['column'].to_i] = miss ? Game::MISS : value * -1
      game.save!
      Turbo::StreamsChannel.broadcast_replace_later_to :games, target: dom_id(game, :meta), partial: 'games/meta', locals: { game: }
      Turbo::StreamsChannel.broadcast_replace_later_to dom_id(game), target: dom_id(game), partial: 'games/game', locals: { game: }

      respond_to do |format|
        format.html { redirect_to(game_path(game), notice: miss ? 'MISS.' : 'HIT!!!') }
        format.turbo_stream do
          @game = game
          @sound_path = miss ? '/audio/WW_Salvatore_Sploosh.mp3' : '/audio/WW_Salvatore_Kerboom.mp3'
        end
      end
    end
  end
end
