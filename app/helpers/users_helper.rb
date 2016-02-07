module UsersHelper
  
  def mdm_words
    
    words = {}
    
    # Internships/Jobs
    # Coloquium
    # Music
    # A capella
    # Personal Financials
    # Startups and Entrepreneurship 
    words["Internships and Jobs"] = "internship,job,resume,apply,program,recruiting,recruit,recruitment,part-time"
    
    words["Colloquiums"] = "colloquium"
    
    words["Startups and Entrepreneurship"] = "startup,entrepreneur"
    
    words["A cappella"] = "ephoria,accidentals,octet,springstreeters,good question,ephlats,elizabethans,aristocows"
    
    return words
  end
end
