Attendees: [Bob][], [Gilad][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha

(Kasper couldn't make it today.)

## The proposal queue

Gilad met with Lars earlier to talk about our overall proposal process. Any
proposal takes real time to implement and maintain, and I we want make sure we
are being strategic—will this help many Dart users significantly?—and not just
tactical—is it a good feature?

The current DEP process doesn't really accommodate that. We review the
proposals that people care to submit and work them through the queue as quickly
as we can. Proposals can make their way through the pipeline more quickly than
the implementation teams can consume them.

We could accept DEPs and then let them hang out for a while. But we think that
leaves the language in a weird state where there are things in the spec that
aren't implemented and where users don't know when they will be.

This may involve occasionally tabling a good proposal. Proposals may enter a
"we like this but not right now state" or something informal along those lines.

The C# team picks a theme for each major release and then prioritizes language
changes that fit that theme and defers ones that don't. We may want to do
something similar.

Having said that, let's run through what we have:

### Metadata

Patrice just filed a DEP about supporting metadata annotations in more places
on types. Alas, we haven't had time to look at it yet.

### [#28 Static analysis of calls on functions][28]

[28]: https://github.com/dart-lang/dart_enhancement_proposals/issues/28

We know what to do here and are happy with it. It's sitting waiting for Lasse
to make some spec changes right now, and Gilad will offer to help out. This one
should move forward.

### [#26 Full optional parameters][26]

[26]: https://github.com/dart-lang/dart_enhancement_proposals/issues/26

This is nice to have, but we don't feel it's something important to focus on
now.

### Configuration-specific code

There have been a handful of proposals here, and we (relevant people on the
Dart team) spent a bunch of time during the Summit discussing it.

I (Bob) am on the hook for fleshing out my [half-baked strawman][extern] since
it seems to pretty promising. I haven't had time to work on it lately since
I've been trying to get the [formatter][] working better, but I'll try to carve
out some time. If I can't, I'll at least find someone who can. I don't want to
be slowing things down.

[formatter]: https://github.com/dart-lang/dart_style/tree/rules
[extern]: https://github.com/munificent/dep-external-libraries

Lars and lots of other people feel solving this problem is really important.

### [Generic methods][generic methods]

[generic methods]:

Gilad is near finishing a draft spec for this. It includes a couple of choice
points for different ways it could go. The plan is for Gilad to meet with Leaf
periodically and see how the draft looks.

At some point, we'll start prototyping/experimenting with an implementation.
The proposal won't move forward without that.

The [DDC][] folks (who are the main drivers of the proposal) and working more
closely with the analyzer folks (where much of the static analysis side of the
proposal will be implemented), so that's helping.

[ddc]: https://github.com/dart-lang/dev_compiler
[analyzer]: https://github.com/dart-lang/sdk/tree/master/pkg/analyzer

There's a lot more to it than just static analysis though. It needs runtime
support too, so we aren't near any kind of official DEP decision on it.

### The `const` proposals

The [constant function literals][const fn] and [eliding `const`][elide]
proposals are both nice to have but aren't something we want to focus on.
That's OK, though, since they're both still drafts that haven't been
"officially" sent to us. :)

[const fn]: https://groups.google.com/a/dartlang.org/forum/#!topic/core-dev/W9zZt9T4ciA
[elide]: https://groups.google.com/a/dartlang.org/forum/#!topic/core-dev/It2sBgpdIG8

### Less restricted mixins

Gilad has [a proposal][mixins] to allow `super()` calls in mixins. The Polymer
JS folks, among lots of others really want this, and Lars does too.

[mixins]: https://github.com/gbracha/lessRestrictedMixins

We'd definitely like feedback on it from users, though it's simple and clean
enough that we don't expect many surprises.

## July

Many of our Danish teammates go on holiday during the summer. Gilad also needs
to spend a good chunk of time this summer finishing off the Dart book he is
writing.

So, we're going cancel DEP meetings in the month of July. Call it a summer
vacation.

Other proposal work can and should still proceed. File issues, iterate on
proposals, start experimental implementations. But, at this point, the teams
have enough work on their plates that we can take a short break and not push
any more accepted proposals onto them.

Lastly, I brought up the proposal that I'm most personally excited about...

## [Non-nullable types and non-nullable by default][nnbd]

[nnbd]: https://github.com/dart-lang/dart_enhancement_proposals/issues/30

We think we can make this fly. We, of course, want to do an implementation and
see how it feels before we commit to it, but everyone seems to be positive
about it.

The main remaining concern is just to see what the real-world experience of
using it is. But that's a tractable problem: we can do a prototype
implementation and run the experiment.

We feel it's really valuable.
