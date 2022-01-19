json.game do
  json.score @game.score
  json.status @game.status
  json.current_word do
    json.status @word.status
    json.success @word.attempts.last.guess == @word.to_guess
    json.attempts @word.attempts do |attempt|
      json.guess attempt.guess
      json.letters attempt.guess.each_char.with_index.to_a do |letter, i|
        json.letter letter
        if @word.to_guess[i] == letter
          json.result 'correct'
        elsif @word.to_guess.include?(letter)
          json.result 'wrong_position'
        else
          json.result 'not_in_word'
        end
      end
    end
  end
end
