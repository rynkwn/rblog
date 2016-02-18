module ApplicationHelper
  
  # Creates the title on a per-page basis
  def full_title(page_title = '')
    base_title = "aRg"
    
    page_title.empty? ? base_title : page_title
  end
  
  # Creates a page description on a per-page basis for analytics purposes.
  # Given the relatively large number of Admin pages, I'll specify
  # which pages I want to track hits for.
  def page_desc(desc = '')
    base_desc = "Admin"
    
    final_desc = desc.empty? ? base_desc : desc
    hit(final_desc)
  end
  
  # Generates the subtitle.
  def subtitle
    subtitles = [
                  "We do not endorse piracy.",
                  "Hello, World",
                  "Who reads subtitles anyways?",
                  "I'm not paid enough for this.",
                  "o_o",
                  "Han shot first",
                  "Jar Jar was not the worst thing. It was the droids."
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
  
  private
  def hit(page_desc)
    if !UNTRACKED_PAGES.include?(page_desc)
      Hit.create(page: page_desc, date_created: Time.now)
    end
  end
end
