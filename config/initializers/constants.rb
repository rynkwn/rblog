# Application Constants
NAME_OF_SITE = "aRg"
UNTRACKED_PAGES = %w[ Analytics Admin ]

# Postmark Constants
POSTMARK_API_KEY = "94252afc-de91-441e-9d0b-495a6ccadd42"  # (Manually inserted into application.rb)
SENDER_SIGNATURE = 'rhk1@williams.edu'
CLIENT = Postmark::ApiClient.new(POSTMARK_API_KEY)

# Daily Message Constants
DAILY_MESSENGER_KEYWORDS = {
  "A cappella" => " ephoria, accidentals, octet, springstreeters, good question , ephlats, elizabethans, aristocows",
  "Competitions" => " competition, contest, tournament, cash prize",
  "Food! (and Meals)" => " dining services, theme dinner, spring dinner",
  "Internships and Jobs (General)" => " recruiter, internship, job, part-time, full time, full-time, route 2, career center, employment, on-campus recruit, earn cash, apply to be",
  "Finance + Consulting Internships" => " investment banking, investment management, consulting firm, consultant internship, strategy consulting, jp morgan, j.p morgan, j.p. morgan, jp. morgan, barclays, goldman sachs, mckinsey, consulting, summer analyst",
  "Literature/Magazines" => " magazine, prose, short stories, poetry, literary, literary magazine",
  "Music (Events, Auditions)" => " audition, composer, recital, musician, pianist, cellist, master class , concert ", # concert?
  "Spiritual Events" => " worship , faith ",
  "Startups and Entrepreneurship" => " startup , entrepreneur ",
  "Talks (Economics and Politics)" => " crops, global studies, cde , poec , political economy , economics department seminar, inequality , welfare , economics , justice ",
  "Talks (Philosophy)" => "philosophy"
}

# If a message contains these words, then for a key_word, we reject that message
# regardless of what else it contains.
DAILY_MESSENGER_ANTI_KEYWORDS = {
  "Competitions" => "basketball,golf,hockey,colloquium,join us for dinner at math puzzle night",
  "Food! (and Meals)" => "",
  "Internships and Jobs (General)" => "meditation,colloquium,lecture,volunteer",
  "Literature/Magazines" => "magazines,screening,perform",
  "Music (Events, Auditions)" => "dance,documentary,theatre,theater,talk, economic, lecture",
  "Talks (Economics and Politics)" => "screening,movie,film",
  "Spritual Events" => "prize,competition, wcma "
}

DAILY_MESSENGER_SENDERS = {
  "All Campus Entertainment (ACE)" => " ace ,all-campus entertainment,all campus entertainment",
  "Art Department" => "art department",
  "Athletics Department" => "athletics",
  "Career Center" => "career center",
  "Chaplain's Office" => "chaplain's office,chaplains office,chaplain",
  "Computer Science Department" => "computer science department",
  "Department of Biology" => "biology department",
  "Department of Chemistry" => "chemistry department",
  "Department of Psychology" => "psychology department",
  "Davis Center" => "davis center",
  "Eph Business Association" => "eph business association",
  "Mathematics and Statistics" => "mathematics,statistics",
  "Music Department" => "music department",
  "Office of Financial Aid" => "financial aid",
  "Williams College Museum of Art" => "wcma,williams college museum of art",
  "Williams Christian Fellowship" => "williams christian fellowship"
}

# For a given topic or sender, do we want it to only check a specific category?
DAILY_MESSENGER_CATEGORY_MAPS = {
  "Talks (Economics and Politics)" => "=== Lectures/Films/Readings/Panels ===",
  "Talks (Philosophy)" => "=== Lectures/Films/Readings/Panels ==="
}