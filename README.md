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