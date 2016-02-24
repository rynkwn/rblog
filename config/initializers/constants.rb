# Application Constants
NAME_OF_SITE = "aRg"
UNTRACKED_PAGES = %w[ Analytics Admin ]

# Postmark Constants
POSTMARK_API_KEY = "94252afc-de91-441e-9d0b-495a6ccadd42"  # (Manually inserted into application.rb)
SENDER_SIGNATURE = 'rhk1@williams.edu'

# Daily Message Constants
DAILY_MESSENGER_KEYWORDS = {
  "A cappella" => "ephoria,accidentals,octet,springstreeters,good question,ephlats,elizabethans,aristocows",
  "Competitions" => "prize,competition",
  "Food! (& Meals)" => "log lunch,log dinner,pizza,donut",
  "Internships and Jobs (General)" => "internship,job,part-time,full time,full-time,route 2",
  "Finance + Consulting Internships" => "investment banking,investment management,consulting firm,consultant internship,strategy consulting,jp morgan,j.p morgan, j.p. morgan,jp. morgan,barclays,goldman sachs",
  "Literature/Magazines" => "magazine,prose,short stories,poetry,literary,literary magazine",
  "Music (Events, Auditions)" => "audition,composer,recital,musician",
  "Spiritual Events" => "worship",
  "Startups and Entrepreneurship" => "startup,entrepreneur",
  "Talks (Economics and Politics)" => "test"
}

DAILY_MESSENGER_SENDERS = {
  "Athletics Department" => "athletics",
  "Career Center" => "career center",
  "Chaplain's Office" => "chaplain's office",
  "Department of Biology" => "biology department",
  "Department of Chemistry" => "chemistry department",
  "Department of Psychology" => "psychology department",
  "Davis Center" => "davis center",
  "Eph Business Association" => "eph business association",
  "Mathematics and Statistics" => "mathematics,statistics",
  "Office of Financial Aid" => "financial aid",
  "Williams College Museum of Art" => "wcma,williams college museum of art",
  "Williams Christian Fellowship" => "williams christian fellowship"
}

# For a given topic or sender, do we want it to only check a specific category?
DAILY_MESSENGER_CATEGORY_MAPS = {
  "Talks (Economics and Politics)" => "=== lectures/films/readings/panels ==="
}