module Stringutils
  
  # Given a normal String, convert it to an HTML-friendly format.
  # @param str The string we're converting.
  # @param email If true, we assume it's normal text to be rendered into an email.
  def Stringutils.to_html(str, email=true)
    str = email ? "<pre style=\"font-family:verdana; font-size:100%; font-color:#000000;\">" + str + "</pre>": 
                  "<pre>" + str + "</pre>"
  end
  
  # Given a normal String in markdown like format, convert it to HTML.
  def Stringutils.markdown_to_html(str)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                      no_intra_emphasis: true, 
                                      fenced_code_blocks: true,   
                                      disable_indented_code_blocks: true,
                                      autolink: true)
    return markdown.render(str).html_safe
  end
  
  #############################################################
  #
  # Generic Functions
  #
  #############################################################
  
  # Returns true if String contains any digit.
  def Stringutils.has_digit(str)
    nums = ('0'..'9').to_a
    for num in nums
      if str.include? num
        return true
      end
    end
    
    return false
  end
  
  # Checks to see if str can be reasonably interpreted to be a time.
  # Does not take military time into account.
  def Stringutils.is_time(str)
    
    # If the time is just a string representation of an integer,
    # the below must be true.
    hour_test = Proc.new {|time|
      time = time.gsub(/[(pm)|(am)]/, '')  # Strip out am or pm.
      time_int = time.to_i
      time.length <= 2 && time_int > 0 && time_int < 13
    }
    
    minute_test = Proc.new {|time|
      time = time.gsub(/[(pm)|(am)]/, '')  # Strip out am or pm.
      time_int = time.to_i
      time.length <= 2 && time_int >= 0 && time_int <= 59
    }
    
    if str.nil?
      return false
    elsif str.include? ":"
      substr = str.split(":")
      if hour_test.call(substr[0]) && minute_test.call(substr[1])
        return true
      else
        return false
      end
    elsif hour_test.call(str)  # Assume it represents an hour
      return true
    else
      return false
    end
  end
end