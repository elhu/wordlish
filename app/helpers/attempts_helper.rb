module AttemptsHelper
  def letter_class(result)
    case result
    when 'correct'
      'dark:bg-green-500'
    when 'wrong_position'
      'bg-yellow-300'
    else
      'dark:bg-gray-800'
    end
  end

  def attempt_result(guess, to_guess)
    to_guess = to_guess.dup
    res = map_correct_guesses(guess, to_guess)
    map_incorrect_guesses(res, guess, to_guess)
  end

  def map_correct_guesses(guess, to_guess)
    res = []
    guess.each_char.with_index.each do |c, i|
      next unless to_guess[i] == c

      to_guess[i] = '.'
      res[i] = [c, 'correct']
    end
    res
  end

  def map_incorrect_guesses(res, guess, to_guess)
    guess.each_char.with_index.each do |c, i|
      next if res[i]

      if (idx = to_guess.index(c))
        to_guess[idx] = '.'
        res[i] = [c, 'wrong_position']
      else
        res[i] = [c, 'not_in_word']
      end
    end
    res
  end
end
