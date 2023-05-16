module Games
  class GuessesController < ApplicationController
    def create
      game = Game.find(params[:game_id])
      value = game.board[params['row'].to_i][params['column'].to_i]
      miss = value == Game::EMPTY_SPACE

      game.board[params['row'].to_i][params['column'].to_i] = miss ? Game::MISS : value * -1
      game.save!

      redirect_to(game_path(game), notice: miss ? 'MISS.' : 'HIT!!!')
    end
  end
end