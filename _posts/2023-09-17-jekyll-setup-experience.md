---
title: Setting up a personal resume website with Jekyll and WSL
---

When Blackbird informed me that I would be on working notice, I figured now is as good a time as any to look at migrating from a standard resume document to a website. It'd be more befitting of my line of work, and help establish _some_ kind of portfolio. That's an element I've been sorely lacking from my professional repertoire, with all my previous work being in private organizations. It wouldn't really look very appealing to anyone if the site didn't have any content, so I'm also going to be taking notes as I go through the process of figuring this thing out, which will become my first post on the site (that isn't the resume, of course).
Music mood during development: synthwave + saxophone - [Neo Noir by Alex Boychuk][neonoir]


## Choosing the tech stack

I've had peripheral awareness of Jekyll for some time, so it was one of the first options I looked at when I started browsing around for static site generators. Simple, well supported, well established, great docs. I also looked at a few others, but I eliminated them for a few reasons:

* Middleman: it looks very powerful, and that's the main reason I counted it out. If I chose something too complex, I know I'd get lost in the technical details all too quickly, and end up pouring hours into some tiny detail without getting any actual writing done. If I decide to do something more sophisticated with this site, I might come back to it.
* Blazor WASM: I've _really_ wanted to play around with Blazor for quite some time now. It'd be a logical extension to the C# and dotNet I've been learning at Blackbird and in my personal time, and honestly, I just think it's neat. That said, it'd quite likely suffer from the same drawbacks as Middleman, not to mention that it doesn't really have any other niceties built-in for site generation like Jekyll or Middleman. I'd love to try it out in the future, perhaps by porting this site.

I ran the subject by the BBI layoff support group, and Jekyll was endorsed over there, too. I used Ruby back when I worked at Intiveo (nee EasyMarkit) for AWS' very strange custom Chef implementation that they call OpsWorks Stacks, and I really quite liked it. Working with Ruby again, even a little, is a welcome proposition. I was sold!
> 💭 Rather, _called_. Turns out they've just end-of-life'd the service. Shame, I thought it was genuinely an excellent platform for hosting complex traditional sites.

## Establishing the working environment

I've spent enough time working with Ruby on Windows to know that I didn't want to do that to my personal machine, so I decided to try using WSL instead, after some positive experiences using it at work and while checking out the legendary [FasterThanLime's Rust introduction][ftl-rust-intro].
> 💭 You can see that [here][my-rust-garbage] if you _really_ want to. I stopped when it came time to introduce some SaaS elements.

I yanked the usual Ruby suspects `rbenv` and `bundler`, made the directory, pinned Ruby to 3.2.2, and declared the `jekyll` gem in my Gemfile. Not long after that, though, I swapped over to the `github-pages` gem for maximum compatibility. Then, a simple `bundle exec jekyll new`, and I had pretty much everything I needed! Jekyll's lovely [tutorial][jekyll-tutorial] carried me along from there.

I was getting pretty tired of hitting up on my keyboard to find the right Jekyll command, and typing out `bundle exec jekyll` over and over was getting old, so I also set up some VS Code tasks, following the nice [Jekyll Problem Matchers extension][jekyll-matchers-extension]'s template. Nice! Easy invocations of `serve`, with a bonus of integration into VS Code. The WSL extension even auto-forwards the ports! I haven't spent much time in the web dev world at all, so it's been fascinating watching just how integrated and automated things have gotten.

## Following the tutorial

Eh, nothing really interesting happening at this point. I'll come back when I start writing my resume in here.

## Writing the resume functionality

One of the main outcomes I wanted from this was a resume that would format itself. I would just have to write a bit of content, and the engine would take care of the rest. No more `Willem Toorenburgh Resume 2023.rtf`! No more fussing with replicating formatting and dealing with copy-pasta!

In service of this, it made the most sense to turn most sections of my resume into Jekyll _collections_. Give them some well-known metadata in the front matter:

{% highlight yaml linenos %}
company:
  name: Blackbird Interactive
  location: Vancouver, BC
position: Senior Platform Engineer
dates:
  start: 2021-09-20
{% endhighlight %}

...and a little creative rendering logic:

{% highlight liquid linenos %}
{% raw %}
{% comment -%}
TODO: remove this assign once we're on Jekyll 4
Also, using block comment because single line comment detection seems broken
{% endcomment -%}
{% assign experience_by_date = site.experience | sort: "dates.start" | reverse -%}
{% for experience in experience_by_date %}
  <section>
  <h3>
    <span class="title-plus-company">
      <em class="title">{{ experience.position }}</em>
      at
      <em class="company">{{ experience.company.name }}</em>
    </span>
  </h3>
  <p class="job-duration-location">
    <time datetime="{{ experience.dates.start | date: '%Y-%m' }}">{{ experience.dates.start | date: '%B, %Y' }}</time>
    -
    {% if experience.dates.end %}
      <time datetime="{{ experience.dates.end | date: '%Y-%m' }}">{{ experience.dates.end | date: '%B, %Y' }}</time>
    {% else %}
      Present
    {% endif %}
    | {{ experience.company.location }}
  </p>
  {{ experience.content }}
  </section>
  <hr>
{% endfor %}
{% endraw %}
{% endhighlight %}

...and just like that, the resume builds itself! I ended up doing similar things for the skills section

## Styling the resume (and everything else)

Next up was page layout. This meant diving into CSS, something I haven't done in quite a while. Thankfully, CSS has evolved significantly in the last 11 years: CSS grid seemed perfect for what I needed. Some research time later, and I was ready to give it a shot! The result was the layout you're reading this in now. Check out the grid view in the dev tools, if you like! I spent a good bit of time fussing with it, wondering why my changes weren't doing anything, until I realized I was fighting the Jekyll built-in theme. Lessons (re-)learned: CSS precedence is important, and make sure you disable all styling before trying your own!

In service of that, I ended up throwing out all built-in Jekyll theming. It was time to embrace the philosophy of the [Motherfucking][mf1] [websites][mf2]. Sure, it may not look as good, and it definitely will take more effort, but I was losing so much time fighting to make my own changes stick that a blank canvas was preferable. Indeed, once I did so, I began making much more progress.

Another thing I wanted was the ability to print the resume out to a PDF and have it look good. The solution for this, thankfully, is quite straightforward: the `@media print` directive. I created a separate `print.scss` and got to rearranging. Another lesson learned: keep it simple. I tried to get fancy and use a bunch of different CSS grid directives, but it turns out that CSS is smarter than me. It only took a few rules to get the page into good form for print, though after much trial and error. *109 tabs* of trial and error. Same for formatting for mobile.

A huge thanks to DigitalOcean for their lovely CSS-Tricks site. I leaned especially hard on their _[Complete Guide to CSS Grid][complete-guide]_ and _[Responsive Layouts Using CSS Grid][responsive-grid]_ guides. I'll need to review the latter again at a later date to perhaps remove my need for my `mobile.scss` sheet, though the effort to payoff ratio of that is questionable at best. Another thanks to [CSS Media Queries][css-media], which does exactly what it says on the tin.

## Going live

I was surprised by how straightforward it was to put this all together, all things considered (CSS notwithstanding, of course). And, by how much I enjoyed it! VS Code and the rich ecosystem supporting web development makes for an impressively smooth experience. There was one stumble with Github Actions failing to build the site, seemingly caused by the `github-metadata` gem that comes with the `github-pages` gem. The build issue was fixed by adding `repository: WillemToorenburgh/WillemToorenburgh.github.io` to the `_config.yml` file... for _some_ reason. Honestly, I'm not even convinced it even had to do anything with it, and I may have just hit a strange service hiccup. But here we are, live on the internet. All is well.

Thanks for reading!

[neonoir]: https://www.youtube.com/watch?v=XwlNtOtQ--Q
[ftl-rust-intro]: https://fasterthanli.me/series/building-a-rust-service-with-nix
[my-rust-garbage]: https://github.com/WillemToorenburgh/rust-explore
[jekyll-tutorial]: https://jekyllrb.com/docs/step-by-step/01-setup/
[jekyll-matchers-extension]: https://marketplace.visualstudio.com/items?itemName=osteele.jekyll
[mf1]: https://motherfuckingwebsite.com/
[mf2]: http://bettermotherfuckingwebsite.com/
[complete-guide]: https://css-tricks.com/snippets/css/complete-guide-grid/
[responsive-grid]: https://css-tricks.com/look-ma-no-media-queries-responsive-layouts-using-css-grid/
[css-media]: http://cssmediaqueries.com