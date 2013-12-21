module EmailHelper

  def border_1
    "1px solid #CCC"
  end

  def quote_border
    "1px solid #80A0C0"
  end

  def quote_bg
    "bgcolor = '#8AC'"
  end

  def quote_cols
    "<td  width = '3%'></td><td width = '1px' bgcolor='#80A0C0'></td><td  width = '3%'></td>".html_safe
  end

  # There are some strings (like times) that email clients will unwantedly
  # enhance into clickable targets.  This gets around that.
  def spanify_characters(string)
    string.chars.map {|c| "<span>#{c}</span>" }.join.html_safe
  end
end
