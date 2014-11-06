describe 'Data.English', ->
  describe 'articleFor', ->
    {articleFor} = Structural.Data.English

    it 'uses "an" for words starting with a vowel', ->
      expect(articleFor('antimony')).toBe('an')
      expect(articleFor('eigenvalue')).toBe('an')
      expect(articleFor('ignominy')).toBe('an')
      expect(articleFor('ostentatious')).toBe('an')
      expect(articleFor('unguent')).toBe('an')

    it 'uses "a" for words not starting with a vowel', ->
      expect(articleFor('radical')).toBe('a')
      expect(articleFor('queue')).toBe('a')
      # Everyone who uses 'an' in front of h's is awful.
      expect(articleFor('history')).toBe('a')
