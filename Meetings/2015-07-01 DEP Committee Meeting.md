Attendees: [Bob][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

The team has been discussing prioritizing language changes so that we spend our
time on the most urgent issues facing users. There's some worry that maybe some
stuff that's already made its way into the spec but that hasn't been
implemented yet isn't actually that high of a priority.

The example that came up is [generalized tear-offs][tear-offs]. This was one of
the first proposals and it made its way though TC52 and into the spec quickly.

[tear-offs]: https://github.com/gbracha/generalizedTearOffs

Now we're looking at other issues that we feel may be more worth spending
engineering time on today than implementing generalized tear-offs. Part of the
problem is that it seems like there aren't many people that really like the
feature. If we were more excited about it, we'd probably be more eager to make
the time to get it done.

After some discussion, our feeling is that our only real option is to just
implement the feature and move forward. It is in the spec and we are committed
to fully implementing the language as specified. Of course, this is a reminder
that the burden is on us to make sure everything that makes it into the spec is
a feature we are really believe in.

## [External libraries][]

[external libraries]: https://github.com/munificent/dep-external-libraries

I finished one revision of my in-progress proposal for handling
configuration-specific code and hopefully other use cases. I've gotten some
good feedback but haven't had time to incorporate it yet. (I got sucked into
helping out another group with some bugs.)

Right now, I'm going through the external methods declared in our core
libraries to get a better picture of which concrete "patching" features they
need, in particular how patch files interact with library privacy.

Kasper brought up that the current patch system causes a lot of complexity in
dart2js so that might be a concern with the proposal. My hope is that by going
through and specifying the semantics in detail, we may have a chance to
simplify them a bit as well, but that depends entirely on what features we
actually need for our core libraries to function.

## [Non-nullable types and non-nullable by default][nnbd]

[nnbd]: https://github.com/dart-lang/dart_enhancement_proposals/issues/30

This is trucking along well. There's a ton of energy, and Patrice is putting a
lot of time into it. He's revised his proposal while we're still working on
digesting the original one. We may end up having to implement both to compare
them.

On our end, we need to start tracking the experimental implementation more
tangibly. We don't intend to accept the DEP until we have a working
implementation. I'll file some bugs to manage this.

*(The main tracking bug is now
[here](https://github.com/dart-lang/sdk/issues/23766)).*

## Implementing proposals

We've gotten some feedback from the team that they aren't sure what in-progress
DEPs they should be testing out and prototyping, and what they shouldn't. The
official answer is that we'll let them know explicitly (by filing bugs) when a
DEP is ready for an experimental implementation and we'd like them to put work
into it. Until then, they shouldn't have to worry about it.

(We talked a bit about making "ready for team to try" being an official state a
DEP can be in, but for now we'll try to keep the flowchart simple.)

Once a DEP is accepted (if not before!), we can ask the team to start
implementing it. We just need to ensure it's behind an experimental flag until
the feature has been approved by TC52.

*(The tracking bug for super() calls in mixins is
[here](https://github.com/dart-lang/sdk/issues/23770). Generalized tear-offs is
[here](https://github.com/dart-lang/sdk/issues/23774).)*

## Summertime!

Like we mentioned before, a combination of writing schedules and vacation means
that we'll be putting the DEP meetings on hiatus until August 5th. In the
meantime, we'll keep cranking on some of the other in-progress proposals like
non-nullable types.
