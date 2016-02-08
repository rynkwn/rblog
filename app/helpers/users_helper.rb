module UsersHelper
  
  def mdm_words
    
    words = {}
    
    # Internships/Jobs
    # Coloquium
    # Music
    # A capella
    # Personal Financials
    # Startups and Entrepreneurship 
    words["Internships and Jobs"] = "internship,job,apply,program,recruiting,recruit,recruitment,part-time,route 2"
    words["Colloquiums"] = "colloquium"
    
    words["Startups and Entrepreneurship"] = "startup,entrepreneur"
    words["A cappella"] = "ephoria,accidentals,octet,springstreeters,good question,ephlats,elizabethans,aristocows"
    
    words["Competitions"] = "prize,compete,competition"
    words["Food! (& Meals)"] = "dinner,lunch,pizza"
    
    words["Literature/Magazines"] = "magazine,prose,short stories,poetry,literary,literary magazine"
    words["Music (Events, Auditions)"] = "audition,singing,cello,cellist,violist,viola,violin,quartet,quintet,tune,bass"
    
    return words
  end
  
  def mdm_senders
    
    senders = {}
    
    # Mathematics and Statistics
    # Department of Biology
    # Department of Chemistry
    # Department of Psychology
    # Career Center
    # Office of Financial Aid
    # Davis Center
    # Williams College Museum of Art
    # Athletics Department
    senders["Mathematics and Statistics"]= "mathematics,statistics"
    senders["Department of Biology"] = "biology department"
    
    senders["Department of Chemistry"] = "chemistry department"
    senders["Department of Psychology"] = "psychology department"
    
    senders["Career Center"] = "career center"
    senders["Office of Financial Aid"] = "financial aid"
    
    senders["Davis Center"] = "davis center"
    senders["Williams College Museum of Art"] = "wcma,williams college museum of art"
    
    senders["Athletics Department"] = "athletics"
    
    return senders
  end
end
