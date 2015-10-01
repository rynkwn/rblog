module ApplicationHelper
  
  # Creates the title on a per-page basis
  def full_title(page_title = '')
    base_title = "aRg"
    if page_title.empty?
      base_title
    else
      base_title + ": " + page_title
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
  
  # Renders markdown text into HTML
  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                      no_intra_emphasis: true, 
                                      fenced_code_blocks: true,   
                                      disable_indented_code_blocks: true)
    return markdown.render(text).html_safe
  end
end
