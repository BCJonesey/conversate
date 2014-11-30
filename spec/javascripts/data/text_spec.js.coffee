describe 'Data.Text', ->
  describe 'annotateUrls', ->
    {annotateUrls} = Structural.Data.Text

    it 'annotates text with no urls', ->
      annotated = annotateUrls('foo bar baz')

      expect(annotated).toEqual([{type: 'text', value: 'foo bar baz'}])

    it 'annotates text with one url', ->
      annotated = annotateUrls('foo http://example.com baz')
      expect(annotated).toEqual([
        {type: 'text', value: 'foo '}
        {type: 'url', urlType: 'url', value: 'http://example.com'}
        {type: 'text', value: ' baz'}
      ])

    it 'annotates text with an image url', ->
      annotated = annotateUrls('foo http://example.com/cat.jpg baz')
      expect(annotated).toEqual([
        {type: 'text', value: 'foo '}
        {type: 'url', urlType: 'image', value: 'http://example.com/cat.jpg'}
        {type: 'text', value: ' baz'}
      ])

    it 'annotates url at start and end of text', ->
      annotated = annotateUrls('http://example.com bar http://example.com')
      expect(annotated).toEqual([
        {type: 'text', value: ''}
        {type: 'url', urlType: 'url', value: 'http://example.com'}
        {type: 'text', value: ' bar '}
        {type: 'url', urlType: 'url', value: 'http://example.com'}
        {type: 'text', value: ''}
      ])

    it 'annotates urls with punctuation', ->
      annotated = annotateUrls('(https://en.wikipedia.org/wiki/The_West_Wing_(season_2))')
      expect(annotated).toEqual([
        {type: 'text', value: '('}
        {type: 'url', urlType: 'url', value: 'https://en.wikipedia.org/wiki/The_West_Wing_(season_2)'}
        {type: 'text', value: ')'}
      ])
