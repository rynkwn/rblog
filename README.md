The code repo for the blogging platform -INSERT URL HERE-

# Why do you have a RoR code repo?
So while I am interested in blogging some of my experiences in startups and 
side projects, it seemed like a good opportunity to also play A LOT with Rails,
HTML, CSS, some dialect of J-Script, and a variety of other things which I've
tampered with, but haven't quite had the freedom to explore.

# Step One - Fail with Devise
Had an in: :range error inside ActiveModel, so, off-handedly, I suppose there's
a conflict between the version of devise I was using and Rails 4.2.1 (which
appears quite new at the time of this writing.)

In the end, in the interest of time and not digging into the given Rails classes,
went with building my own OAuth system. Should be a more interesting exercise that
way.

# Step Two - CSS
Found this site to be useful:
http://www.gotealeaf.com/blog/integrating-rails-and-bootstrap-part-2

I initially went with just SASS, primarily because I had gotten used to the idea
of code that's defined by indentation, and because I enjoyed the idea that 'Hey,
I won't have to bother with semi-colons? Clearly this is the best choice.'

It was not that great a choice. As someone who was relatively new to CSS in general,
I was disheartened to find that a lot of examples appears to be in the SCSS format,
and that the conversions were not always inherently obvious. (Though, I am almost
absolutely sure that there exists a tool that auto-converts between the two styling
formats.)

Additionally, some chunks of code appeared much, much uglier without the curly braces.

# Step Two and a Half - Still trying to make the site look good.
I found this to be really cool: https://24ways.org/2012/how-to-make-your-site-look-half-decent/

And the place where I got my background texture: http://subtlepatterns.com/page/4/
It is the "Fresh snow" pattern by Kerstkaarten.

# Step Three - Setting up a paper trail to handle the inevitable loss of data in the future.
Using http://www.tutorialspoint.com/ruby-on-rails/rails-send-email.htm in order to,
ideally, set up a tool that will auto-email my personal email with key information about
written blog posts. As I have yet to look deeply into reasonably organizing migrations,
especially for a project that is amorphous by definition (hoorah exploration)
and will therefore frequently have updated models, this seems like a reasonable
way of making sure that content survives catastrophic loss.

Heroku does not provide an inbuilt mail service however. Currently leaning towards
using Postmark, as it provides 10k free inbound/outbound messages per month, which
which is more than enough for my purposes.

The tutorialspoint link doesn't appear relevant, given the existence of the
postmark-rails gem.

Additional postmark documentation that allowed me to successfully send an email
manually to my main personal email: https://github.com/wildbit/postmark-gem/blob/master/README.md

Set up a mailer, and a blog_history function that emails my personal email when called.
Oddly enough, I couldn't get the mail() function to work, so I defaulted to the
API approach. I have some concerns over memory leaks since I'm making a new object every
time I want to send an email, but setting the client variable to nil (perhaps
unnecessary?) will hopefully lessen any consequences down the road.

Strongly tempted to look into this deeper in the future and perhaps write a tutorial
on getting Postmark to work.

# Step Four - Changing Everything Again and Adding Content/Functionality.
After a brief hiatus, ultimately determined that I was deeply unhappy with the
aesthetic appearance of the site, and that to make it look good with my mental 
schematic would take a long time.

Long story short, it would have been best to go with the simplest, clean looking
solution, and then iterating on top of that to become more complex/look better.

I've implemented sessions (though not yet complete. Still need to tamper with the
User model in order to differentiate between myself and all other possible users.)
I've also filled out the title section a bit more, added some navigational links,
and I've begun filling in content.

The only question of note: for the About page, I have a small picture of myself.
I'm almost confident I can link to a picture via a URL and load it inside the rails
app, but my initial google searches didn't bring up too many solutions. Future
Rails gem if it doesn't already exist? It'd be nice if the picture auto-updated
as I updated, say, my Github profile page.

# Step Four and a Half - Typography.
The value of those `<p></p>` are finally becoming apparent. Styling blocks of text
to look decent is, unsurprisingly, a non-trivial endeavor. In the end, I went with
this styling for my `<p>`:

        p {
          color: $secondary;
          font-size: 1.2em;
          line-height: 1.7em;
          text-indent: 2em;
          text-align: justify;
          font-family: 'Verdana', Times, "Times New Roman", serif;
        }  

Which goes with normal paragraph-styled, decent looking text. Verdana appears
to be pretty universally popular, though I did try my hand with garamond in order
to appear more "literary." Ultimately the thinness of the resulting font led me
to just copy whatever font Paul Graham was using.

As an extra tool, whatfont is a wonderful Chrome extension. As is ColorZilla. There
is an established way of adding new, custom fonts to your rails app. This stack
overflow question exemplifies it pretty well: http://stackoverflow.com/questions/12329137/how-to-add-a-custom-font-to-rails-app

My understanding is that the @font-face essentially "declares/defines" the font.
I had two separate .ttf files for Garamond (one for regular, one for bold.) I
implemented this by defining two font-faces, both in the font-family Garamond,
with the bold ttf file having a defined font-weight: bold.

## Width of Content
Something else I've discovered. Be careful with how you establish the width of
your content. Many sites, I've noticed, have the content you're most likely to be
interested in centered and dense. This was in marked contrast with my initial body
content, which literally required me to move my head in order to keep reading my
paragraphs.

Easily fixed with modifying these attributes in the body: 
        
        body {
          ...
          margin: auto;
          max-width: 950px;
        }
        
## Blogging and Structure
For those who have no experience with it, I strongly recommend reading Enterprise
Rails. Having said that, I will also admit that I've only read the first 12 chapters
or so thus far. Much of the first 10 chapters deals with ensuring
database integrity: essentially how best to ensure that the data is correct,
and how best to model said data.

Right now I plan to have two models: User and Blog.
As I intend to be the only blogger, all blogs implicitly belong to me, so
both User and Blog are relatively simple.

The only point of concern however is that Blogs will have many different subjects
they can fall under: they can be related to a certain project, perhaps they're
professional, or maybe they're strictly a tech guide. 

All such blogs will be fundamentally the same, but I will want to distinguish
the subject matter when I want to show relevant content to a User who wants to see
"just startup blogs" for example.

        Blog
          t.text :name  # My understanding is that there's no substantial difference
                        # between string and text currently. Though text can store
                        # far more characters than String.
                        # I also believe some search gems like sunspot/elastisearch do
                        # prefer text data. It's possible my memory is faulty on this
                        # however.
          t.text :content
          t.text :tags  # Unsure how much I'll use this. But it'll essentially be
                        # an array of words that describe the main content of the
                        # post.
          t.references :subject
          

### How to Structure the Subject
The subject attribute is relatively static. There's a set number of possible choices,
but that set is expected to change organically with my usage of the site. The best
way to model the Subject, then, is as a separate data table, which I'll populate
/depopulate as needed.

It also makes sense to let Subjects have_many Blogs, in order to let me easily
get all blogs in a certain subject.

        Subject
          t.text: name
          
        Subject Model
          has_many :blogs
        
#### While we're on this subject: 3NF (Third Form Normalization)
The Form Normalizations are characteristics of your database as a whole and how
you've structured data. Basically, if your data is properly normalized, you'll feel
great because everything is clear and clean cut because the relationships 
are all nicely understood and in the open. If your data isn't properly
normalized, things get messy and you're not quite sure who's dating who and there's
a lot more room for errors to creep in unintentionally, leading to issues like
Janet, who DID say she was no longer dating Frank, but Frank still believes he's dating
Janet, when she's actually dating you.

While a precise definition is perhaps outside the scope of this README, I found
this site to be very helpful in easily understanding 1NF, 2NF, and 3NF. (There's
also a 4NF.)
http://www.essentialsql.com/get-ready-to-learn-sql-11-database-third-normal-form-explained-in-simple-english/

### A slight note on the User
It's worth noting that I didn't document the entirety of my process. The User model,
for example, is something I did behind the scenes and didn't tamper the README about.

Hartl's Rails book is a great place to learn how to create a very comparable 
User model/controller: https://www.railstutorial.org/ (Yes, you can read it 
online for free.)

Aside from using bcrypt to encrypt passwords, the only other thing I have of note
is this wonderful little attribute:

        User:
          t.integer :ryan
          
While it may seem like narcissism, my plan is to have this attribute default
to zero for all Users that don't have my email, while for my email the integer
will become 1. This sidesteps the need to create a Superuser model (though I may
have to do that in the future, I'd rather avoid excessive modeling right now), and
ultimately seems like a simpler way of making sure there can only ever be one
"Ryan."

In order to do this, just include:

      User Model
      ...
      after_initialize :ryanize
      
      def ryanize
        self.ryan = self.email == 'rynkwn@gmail.com' ? 1 : 0
        self.save!  # You may need this if you're not on Rails 4.2.1
      end
      
Essentially, after an instance of the model is created, it'll run the init function,
which correctly assigns Ryan-ness. You do need the save afterwards to save the 
change, and save! is used here over save as the latter only turns into false when
an error crops up, while save! returns the error.

(Note, later)
I originally had the function as:

      def init
        ...
      end

but I had an issue where it seemed the init function was run both on creation of
the new object (when the 'new' page loaded), as well as after it was initialized.
It seems init may be a "reserved" function with special purpose in rails.

## Now I get to Write Tests and Validations
Technically. I should have written the tests beforehand, and then created/molded
the various models until the tests passed (Test Driven Development). The reason 
for this, is because Tests
basically mimic, in much greater efficiency, the process I would do otherwise
(which is recompile. Check to see if a feature exists/works. Notice it doesn't.
Fix. Recompile. Repeat.)

It is, in my opinion, unfortunately less satisfying than seeing and manipulating the
results of your work. However, it's also worth noting that I do not currently
know how to write particularly great tests. It's on the list of things I plan
on improving upon. Later. Where I'll write a blog about it and do much more research
on it before playing with it experimentally.

Hartl is, again, a great source to get used to both tests and validations.

## Favicon
The small icon that represents your site!

I took a small break from the mechanics of content-creation on my site to tamper
with the Favicon. Currently, my intention is to upload my Gimp 2 creation to this
site: http://realfavicongenerator.net/

While I have no doubt the above would actually be much more useful in the long run,
the simplest solution I found was to use: http://onlinefavicon.com/
to generate the ico files, and then just attach:

        <%= favicon_link_tag 'name_of_favicon_file_saved_to_assets/images.ico' %>
        
inside `<head></head`

# Step Four and Two Thirds - 

## Indexing (Index Blogs by Subject)

## Getting flashes to work as intended

## Getting Blogs to WYSIWYG.

## Turning off Autocomplete.