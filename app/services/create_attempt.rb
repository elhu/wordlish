class CreateAttempt
  attr_reader :game, :guess, :attempt

  def initialize(params)
    @game = params.fetch(:game)
    @guess = params.fetch(:guess)
  end

  def call
    REDLOCK.lock!("lock:game:#{game.id}", 1_000) { create_attempt }
  rescue Redlock::LockError
    ServiceResponse.new(success: false, errors: { game: ["locked, you can only play 1 attempt at a time per game"] })
  end

  private

  def create_attempt
    @attempt = word.attempts.build(guess: guess, position: next_pos)
    return ServiceResponse.new(success: false, errors: attempt.errors) unless attempt.save

    if should_close_word?
      close_word!
      close_game! if should_close_game?
    end
    ServiceResponse.new(success: true, payload: { attempt: attempt })
  end

  def close_game!
    game.update(status: 'done', score: game.compute_score)
  end

  def close_word!
    word.update(status: 'done')
    game.words.where(status: 'not_started').first&.update(status: 'ongoing')
  end

  def next_pos
    (word.attempts.maximum(:position) || 0) + 1
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
