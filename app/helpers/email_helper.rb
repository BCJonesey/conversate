module EmailHelper

  BORDER_1="1px solid #CCC"

  # There are some strings (like times) that email clients will unwantedly
  # enhance into clickable targets.  This gets around that.
  def spanify_characters(string)
    string.chars.map {|c| "<span>#{c}</span>" }.join.html_safe
  end
end
