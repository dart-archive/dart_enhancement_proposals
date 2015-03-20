Attendees: [Bob][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## Configuration-specific code

We have something like 3 1/2 proposals floating around:

* [Configured imports](https://github.com/dart-lang/dart_enhancement_proposals/issues/6)
* [Configured imports (simplified)](https://github.com/dart-lang/dart_enhancement_proposals/issues/19)
* [Import when](https://github.com/nex3/dep-import-when)
* [External libraries](https://github.com/munificent/dep-external-libraries)

We'd like the committee to have something to look at, but it doesn't seem like
this area is ready to make any decisions yet. We'll let the stakeholders sort
it out in other forums (email, GitHub, etc.) and then get back to us when
things are more settled.

## DEP meetings

We're still learning how to best manage the DEP process and these weekly
meetings, and figure out what they're for. One option is that these meetings
are just for making decisions on a proposal after its solid.

For the detailed design work that leads up to that, we'd encourage people to
have meetings, discussions, pow-wows or whatever they want outside of this
meeting. We can be involved in those too of course.

One risk is that if too much work happens where we don't see it, we may not
have enough context to make good decisions. Or maybe it will just be harder for
us to wrap our heads around and accept a proposal that we aren't intimately
familiar with.

Hopefully authors will capture all of the salient context in the proposal
itself. Our guess is that this will be a longer process. We do want the overall
velocity of Dart to be higher. The trick will be getting that with a more
distributed process.

The real challenge is getting these proposals to all fit together if they are
coming from different groups. Our role then is to make sure Dart works
holistically.

## Iterating on proposals

We could go through each proposal in the meeting and give feedback. Then wait
and see how they respond. By itself, that's not going to be effective. It will
take too many iterations to getting something solid.

Instead, we'll need to continually monitor proposals on the side and give
feedback. For example, Gilad has already started working with [Leaf][] on his
[generic methods][] proposal

[generic methods]: https://github.com/dart-lang/dart_enhancement_proposals/issues/22
[leaf]: https://github.com/leafpetersen/dep-generic-methods

Wanting a high velocity makes it hard to get things perfectly right. We'll
probably have to accept that proposals should be reasonable but may still be
tweaked until it's been implemented and all of the issues have been flushed
out.

## Experimental implementations

Something that would help is being able to implement a proposal while it's
still "in flight". Last year, Lars shared an idea with the team to enable us to
have "experimental" implementations that are hidden behind an opt-in flag.

All tools (VM, dart2js, analyzer, etc.) would handle this flag. Users could
enable it to try out new things with the understanding that experimental
features may and likely *will* have breaking changes.

We got sort of hung up on things like "does the stable channel enable
experiments?" and "can packages on pub require experimental features?" so it
didn't get far but it sounds like it's time to bring this idea back.

Kasper will talk to Lars about it and get his thoughts.

We do have to be careful that experiments don't become a vector for shoehorning
stuff into the language. If an important customer relies on some experiment, we
don't want to end up forced into keeping it. At the same time, knowing that an
experimental feature is used by an important customer is useful data to have.

There's just a risk that we implement an experiment in some hacked together way
and then become unable to clean it up if users rely on the nasty edge case
behavior.

Another potential problem is this runs the risk of making proposals from
authors not on the Dart team second class since they don't have the luxury of
submitting an experimental implementation. Hopefully, though, they will have
champions on the team who are excited enough about the proposal to help out.
And, if we know it's going to be gated behind an experimental flag, we're more
comfortable landing patches from an external contributor.

## Breaking changes

So far, we've been focused on changes that are strict additions to the
language. We haven't considered breaking anything, and in general, we don't
want to. But there may come a time when we want to. Over the next few quarters,
we should think about what that means and have some sort of plan.

If we realize we made some decision in the past and it's hard to live with now,
what can we do? If we want to make a breaking change, do we agonize over each
tiny one, or do a big "Dart 2.0" and ship a batch of them? How do we manage the
transition for our users?

## Next week's meeting

We'll invite [Lasse][] and [Ivan][] and go over the [package spec][] proposal.

[package spec]: https://github.com/dart-lang/dart_enhancement_proposals/issues/5
[lasse]: https://github.com/lrhn
[ivan]: https://github.com/iposva-google

There are still a few [open issues][] from the last time we discussed it. We
can try to settle them in the meeting itself, but it's probably better to try
to get those hammered out offline before the meeting.

[open issues]: https://github.com/lrhn/dep-pkgspec/issues

I'll bug Lasse and see if we can reach decisions on them and update the
proposal.

## More proposals

The configuration stuff still needs work. We need to pare down the variants.

At some point, Gilad intends to write proposals for union types, some changes
to type promotions, and some unspecified stuff. Leaf's [generic methods][]
proposal is coming soon. *[As of this writing, it's out now.]*

What about expanding the set of places where metadata annotations are allowed?
That would help the dev compiler folks. In principle, we'd like to allow them
everywhere. In practice, it's hard to fit that into the spec. Function types in
particular make it harder.

(Function type syntax is something where it might be nice to have the luxury of
making a breaking change to fix.)

There's no shortage of proposals to work on. There may just be a shortage of
things that are ready for the committee to see. That's OK. It might just take a
while to pile up again.
