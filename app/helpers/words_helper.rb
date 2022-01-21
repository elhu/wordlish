module WordsHelper
  def heading_text(word)
    heading = ["Word #{word.position+1}/#{word.game.max_words}"]
    if word.status == "done"
      heading << "- #{word.to_guess.upcase} "
      heading << "#{word.attempts.last&.guess == word.to_guess ? '✅' : '❌'}"
    end
    heading.join(' ')
  end
end
