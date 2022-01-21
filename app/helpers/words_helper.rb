module WordsHelper
  def word_guessed?(word)
    word.attempts.last&.guess == word.to_guess
  end
end
