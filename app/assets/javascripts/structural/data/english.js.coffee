English = {
  articleFor: (word) ->
    if /^[aeiou]/i.test(word) then 'an' else 'a'

  # No Oxford comma.  Deal with it.
  listAsReadableString: (list) ->
    if list.length == 0
      ''
    else if list.length == 1
      list[0]
    else
      "#{list.slice(0, list.length - 1).join(', ')} and #{list[list.length - 1]}"
}

Structural.Data.English = English
