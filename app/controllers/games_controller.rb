class GamesController < ApplicationController
  before_action :set_game, except: [:index]

  def show

  end

  private
  def set_game
    @game = Game.find_by(uuid: params[:id])
  end
end
