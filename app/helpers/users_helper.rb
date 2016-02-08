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
end
