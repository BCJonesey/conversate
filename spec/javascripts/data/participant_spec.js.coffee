describe 'Data.Participant', ->
  it 'knows the name of people that don\'t exist', ->
    expect(Structural.Data.Participant.name(undefined)).toBe('')
    expect(Structural.Data.Participant.name(null)).toBe('')


  it 'knows people\'s names that only have names', ->
    onlyHasName =
      full_name: 'Alice'
      id: 12

    expect(Structural.Data.Participant.name(onlyHasName)).toBe('Alice')

  it 'knows people\'s names that only have emails', ->
    onlyHasEmail =
      email: 'bob@example.com'
      id: 43

    expect(Structural.Data.Participant.name(onlyHasEmail)).toBe('bob@example.com')

  it 'knows people\'s names that have both name and email', ->
    hasBoth =
      email: 'cassie@example.com',
      full_name: 'Cassie',
      id: 94

    expect(Structural.Data.Participant.name(hasBoth)).toBe('Cassie')

  it 'knows people\'s names that have a name', ->
    onlyName =
      name: 'Dave',
      full_name: 'David'
      email: 'dave@example.com'
      id: 91

    expect(Structural.Data.Participant.name(onlyName)).toBe('Dave')
