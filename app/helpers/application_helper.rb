module ApplicationHelper
  
  # Creates the title on a per-page basis
  def full_title(page_title = '')
    base_title = "aRg"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  # Generates the subtitle.
  def subtitle
    subtitles = [
                  "We do not endorse piracy.",
                  "Hello, World",
                  "Who reads subtitles anyways?",
                  "I'm not paid enough for this.",
                  "o_o"
                ]
    subtitles.sample
  end
end
