class AttemptsController < ApplicationController
  before_action :set_game
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    service = CreateAttempt.new(permitted_params.merge(game: @game))
    result = service.call

    respond_to do |format|
      if result.success?
        @word = result.payload[:attempt].word
        format.json { render :create, status: :created }
      else
        format.json { render json: { errors: result.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def permitted_params
    params.require(:attempt).permit(:guess)
  end

  def set_game
    @game = Game.find_by!(uuid: params[:game_id], status: "ongoing")
  end
end
