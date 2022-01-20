module AttemptsHelper
  def letter_class(word, letter, idx)
    if letter == word.to_guess[idx]
      'dark:bg-green-500'
    elsif word.to_guess.include?(letter)
      'bg-yellow-300'
    else
      'dark:bg-gray-800'
    end
  end
end
