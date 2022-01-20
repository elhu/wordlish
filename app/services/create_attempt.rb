class CreateAttempt
  attr_reader :game, :guess, :attempt

  def initialize(params)
    @game = params.fetch(:game)
    @guess = params.fetch(:guess)
  end

  def call
    @attempt = word.attempts.build(guess: guess, position: word.attempts.maximum(:position) + 1|| 0)
    return ServiceResponse.new(success: false, errors: attempt.errors) unless attempt.save

    if should_close_word?
      close_word!
      close_game! if should_close_game?
    end
    ServiceResponse.new(success: true, payload: { attempt: attempt })
  end

  private

  def close_game!
    game.update(status: 'done', score: game.compute_score)
  end

  def close_word!
    word.update(status: 'done')
    game.words.where(status: 'not_started').first&.update(status: 'ongoing')
  end

  def should_close_game?
    game.words.where.not(status: 'done').count == 0
  end

  def should_close_word?
    word.to_guess == guess || word.attempts.count == game.max_attempts
  end

  def word
    @word ||= @game.words.find_by(status: 'ongoing')
  end
end
