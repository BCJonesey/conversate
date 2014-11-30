Text = {
  # This is, to put it bluntly, *some bullshit*.  But it's also about the only
  # way I think this'll work.  String.split is basically useless cross-browser,
  # so we can't use it with the kind of complex regular expressions that we need
  # to find URLs.  URLs are also kind of a pain in the ass, so we've got that
  # baseline level of complexity to deal with.  Here's what I've ended up with:
  # First, we use a modified version of linkify.js from
  # http://jmrware.com/articles/2010/linkifyurl/linkify.html to take our input
  # text and find all the urls in it.  Instead of turning them into HTML links
  # though, we surround the URLs with control characters.  Then we use a very
  # simple (and, hence, cross-browser) split on those control characters to get
  # an array of text and urls.  We annotate that with the type of each url and
  # return it, so that the view can render them how it sees fit.
  #
  # Yeah, it's some bullshit.
  annotateUrls: (text) ->
    surrounded = Structural.Data.Text._surroundUrls(text)
    parts = surrounded.split('\u001E')

    annotated = for part, i in parts
      if i % 2 == 0
        {type: 'text', value: part}
      else
        if /\.(jpeg|jpg|gif|png|svg)$/.test(part)
          urlType = 'image'
        else
          urlType = 'url'

        {type: 'url', urlType: urlType, value: part}

    annotated
}

Structural.Data.Text = Text
