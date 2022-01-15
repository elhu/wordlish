json.game do
  json.uuid @game.uuid
  json.seed @game.seed
  json.max_words @game.max_words
  json.max_attempts @game.max_attempts
  json.word_length @game.word_length
end
