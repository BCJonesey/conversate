English = {
  articleFor: (word) ->
    if /^[aeiou]/i.test(word) then 'an' else 'a'
}

Structural.Data.English = English
