Attendees: [Bob][], [Gilad][], [Kasper][], [Lars][], [Lasse][].

[bob]: https://github.com/munificent
[erik]: https://github.com/eernstg
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl
[lars]: https://github.com/larsbak
[lasse]: https://github.com/lrhn

## Narrower DEP Meetings

The [configured imports][] proposal has significant analysis implications, so
we talked about having [Brian][] join the meetings. The attendee list is
already getting quite large, and it's increasingly hard to be efficient.

[configured imports]: https://github.com/dart-lang/dart_enhancement_proposals/issues/6
[brian]: https://github.com/bwilkerson

Instead of adding yet another warm body, the plan is to cut the core DEP team
down to:

* Bob
* Gilad
* Kasper

They will then invite other attendees in to discuss specific proposals as they
see fit. This should keep the DEP meetings more focused.

For longer design discussions, our hope is that authors of proposals will
arrange and have those meetings themselves with the right stakeholders.

## [Null-aware operators][]

[null-aware operators]: https://github.com/gbracha/nullAwareOperators

Sean Eagen [suggests][6] changing `?=` to `??=` for consistency with other
compound assignment operators. We all agree.

[6]: https://github.com/gbracha/nullAwareOperators/issues/6

Including that change, this DEP is now accepted and on its way to TC 52.

## [Configured imports][]

Since the current proposal seems to be getting complex around its static
analysis story, [I][bob] wanted to sketch out [a rough idea][external] for
something that's simpler to analyze.

[external]: https://github.com/munificent/dep-external-libraries/blob/master/Proposal.md

It avoids the problem of having to "union" multiple libraries together to
determine how the analyzer sees them. However, it also has complexity regarding
what it means to combine an external library with the canonical one. It may be
that as that gets more fully-specified, it ends up as complex as the configured
imports proposal.

The basic question is still do we want configuration to affect the static shape
of the program or not?

If so, we'll have to figure out what the tooling story is. C/C++ IDEs do allow
this using the preprocessor and then just require the user to select which
configuration they're currently looking at.

And, in fact, something like C#'s `#if` would be both a simple and powerful
solution to this problem. But Lars and others definitely don't like that
approach. We really want a library to have a single configuration-independent
API.

If users have to select a configuration, it's too easy for them to not check
one and have configuration-specific bugs.

Since the external libraries strawman is still half-baked it needs more work
before we can see how it compares. We'll iterate on both in parallel and see
where they end up.

Lasse and I and the relevant stakeholders will work together "offline" (i.e. outside of official DEP meetings) on this. I'll talk to the analyzer folks in particular to see how they feel about this.
