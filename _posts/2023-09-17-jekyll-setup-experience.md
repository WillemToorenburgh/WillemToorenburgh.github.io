---
author: willem
title: Setting up a personal resume website with Jekyll and WSL
---

When I was informed I would be on working notice, I figured now is as good a time as any to look at migrating from a standard resume document to a website. It'd be more befitting of my line of work, and help establish _some_ kind of portfolio. That's an element I've been sorely lacking from my professional repertoire, with all my previous work being in private organizations. It wouldn't really look very appealing to anyone if the site didn't have any content, so I'm also going to be taking notes as I go through the process of figuring this thing out, which will become my first post on the site (that isn't the resume, of course).
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

I was getting pretty tired of hitting up on my keyboard to find the right Jekyll commmand, and typing out `bundle exec jekyll` over and over was getting old, so I also set up some VS Code tasks, following the nice [Jekyll Problem Matchers extension][jekyll-matchers-extension]'s template. Nice! Easy invocations of `serve`, with a bonus of integration into VS Code. The WSL extension even auto-forwards the ports! I haven't spent much time in the web dev world at all, so it's been fascinating watching just how integrated and automated things have gotten.

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
TODO: remove this silly assign once we're on Jekyll 4
Also, using block comment because single line comment detection seems broken
{% endcomment -%}
{% assign experience_by_date = site.experience | sort: "dates.start" | reverse -%}
{% for experience in experience_by_date %}
  <li>
    <h3>
      <em>{{ experience.position }}</em>
      at {{ experience.company.name }}
    </h3>
    {{ experience.dates.start | date: '%B, %Y' }} -
    {% if experience.dates.end %}
      {{ experience.dates.end | date: '%B, %Y' }}
    {% else %}
      Present
    {% endif %}
    | {{ experience.company.location }}
    <br>
    {{ experience.content }}
  </li>
{% endfor %}
{% endraw %}
{% endhighlight %}

...and just like that, the resume builds itself!

[neonoir]: https://www.youtube.com/watch?v=XwlNtOtQ--Q
[ftl-rust-intro]: https://fasterthanli.me/series/building-a-rust-service-with-nix
[my-rust-garbage]: https://github.com/WillemToorenburgh/rust-explore
[jekyll-tutorial]: https://jekyllrb.com/docs/step-by-step/01-setup/
[jekyll-matchers-extension]: https://marketplace.visualstudio.com/items?itemName=osteele.jekyll