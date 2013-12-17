module EmailHelper

  def border_1
    "1px solid #CCC"
  end

  def quote_border
    "1px solid #80A0C0"
  end

  # There are some strings (like times) that email clients will unwantedly
  # enhance into clickable targets.  This gets around that.
  def spanify_characters(string)
    string.chars.map {|c| "<span>#{c}</span>" }.join.html_safe
  end
end
