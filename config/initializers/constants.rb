# Application Constants
NAME_OF_SITE = "aRg"
UNTRACKED_PAGES = %w[ Analytics Admin ]

# Postmark Constants
POSTMARK_API_KEY = "94252afc-de91-441e-9d0b-495a6ccadd42"  # (Manually inserted into application.rb)
SENDER_SIGNATURE = 'rhk1@williams.edu'
CLIENT = Postmark::ApiClient.new(POSTMARK_API_KEY)

# Daily Message Constants
DAILY_MESSENGER_KEYWORDS = {
  "A cappella" => "ephoria,accidentals,octet,springstreeters,good question,ephlats,elizabethans,aristocows",
  "Competitions" => "competition,tournament,cash prize",
  "Food! (& Meals)" => "dining services",
  "Internships and Jobs (General)" => "recruiter,internship,job,part-time,full time,full-time,route 2",
  "Finance + Consulting Internships" => "investment banking,investment management,consulting firm,consultant internship,strategy consulting,jp morgan,j.p morgan, j.p. morgan,jp. morgan,barclays,goldman sachs",
  "Literature/Magazines" => "magazine,prose,short stories,poetry,literary,literary magazine",
  "Music (Events, Auditions)" => "audition,composer,recital,musician,pianist,cellist",
  "Spiritual Events" => "worship,spirituality",
  "Startups and Entrepreneurship" => "startup,entrepreneur",
  "Talks (Economics and Politics)" => "global studies,cde,poec,political economy,economics department seminar,inequality,welfare,economics",
  "Talks (Philosophy)" => "philosophy"
}

# If a message contains these words, then for a key_word, we reject that message
# regardless of what else it contains.
DAILY_MESSENGER_ANTI_KEYWORDS = {
  "Competitions" => "basketball,golf,hockey",
  "Literature/Magazines" => "magazines",
  "Music (Events, Auditions)" => "dance",
  "Talks (Economics and Politics)" => "screening"
}

DAILY_MESSENGER_SENDERS = {
  "Athletics Department" => "athletics",
  "Career Center" => "career center",
  "Chaplain's Office" => "chaplain's office,chaplains office,chaplain",
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
  "Talks (Economics and Politics)" => "=== lectures/films/readings/panels ===",
  "Talks (Philosophy)" => "=== lectures/films/readings/panels ==="
}