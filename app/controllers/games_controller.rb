class GamesController < ApplicationController
  before_action :set_game, only: [:show]
  skip_before_action :verify_authenticity_token, only: [:create]

  def show; end

  def create
    @game = Game.new(permitted_params)
    if @game.save
      respond_to do |format|
        format.json { render :create, status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_game
    @game ||= Game.find_by!(uuid: params[:id])
  end

  def permitted_params
    params[:game].present? ? params.require(:game).permit(:max_words, :max_attempts, :word_length, :seed) : {}
  end
end
