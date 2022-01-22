json.game do
  json.score @game.score
  json.status @game.status
  json.current_word do
    json.status @word.status
    json.success @word.attempts.last.guess == @word.to_guess
    json.attempts @word.attempts do |attempt|
      json.guess attempt.guess
      json.letters attempt_result(attempt.guess, @word.to_guess).each do |letter, result|
        json.letter letter
        json.result result
      end
    end
  end
end
