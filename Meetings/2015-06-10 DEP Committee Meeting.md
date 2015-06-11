Attendees: [Bob][], [Gilad][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha

Kasper is travelling for work, so this was a short meeting.

### [#28 Static analysis of calls on functions][28]

[28]: https://github.com/dart-lang/dart_enhancement_proposals/issues/28

Gilad hasn't had time to help out with the spec language here, but he'll try to
find some time.

### [#32 Metadata for type annotations][32]

[32]: https://github.com/dart-lang/dart_enhancement_proposals/issues/32

Patrice recently filed this proposal. We're worried it goes a bit too far. The
proposal for metadata on type *annotations* seems fine, but the section for
adding metadata to other places where types can appear, like runtime type
arguments, is difficult.

I think Patrice put this together as a separate incremental piece towards the
[non-nullable type proposal][nnbd]. By breaking the annotation syntax out into
a separate proposal, it might make it easier to eventually get to non-nullable
types.

My feeling is that this annotation proposal is itself complex enough that it
may actually slow down making progress on non-nullable types (which seem to
already have a pretty good amount of traction).

At the same time, we would like to have metadata in more places where type
annotations can appear. One step forward might be to simplify the proposal to
remove adding metadata to types that are not type annotations.

[nnbd]: https://github.com/dart-lang/dart_enhancement_proposals/issues/30

### Non-nullable types

We'd like to start making concrete progress on prototyping this. The gating
issue right now is nailing down a syntax for the type modifiers. Once we have
that, we can start parsing (and ignoring) it.

Gilad's instinct is to make `?` prefix and `!` postfix. That avoids the obvious
conflicts around the ternary operator with `?` and the negation operator with
`!`.

My feeling is that postfix for both would be a bit more appealing to users.
(For example, C#, Ceylon, and Kotlin all use postfix `?` for this.)

Given that our parsers already have to do a lot of lookahead, this may be
resolvable, though it's certainly nice to not have to rely on that. The right
solution is to probably just ask the parser maintainers to implement one style
and see how it goes.

I'll follow up with Patrice and the relevant VM, analyzer, and dart2js folks
and see if we can try out postfix and see if it works.

If we can to a syntax that we're confident about, we can get it so that the
implementations parse and ignore it. That will then let us experiment with
implementing it in one system first&mdash;probably static
analysis&mdash;without breaking the others.

My hunch is we'll start with the static side of the proposal first because that
will more directly help us answer usability questions about writing code that
deals with non-nullable types. The checked mode behavior matters a lot too, but
people will hit the warnings from non-nullable types statically first.

### Configuration-specific code

This has been quiet for a while, mostly because of me. I'm on the hook for
writing a more detailed proposal for patch files but haven't had the time. I'm
finally over the hump with the formatter work I'm doing, so I should be able to
carve out time for this very soon.

### [Generic methods][generic methods]

[generic methods]: https://github.com/leafpetersen/dep-generic-methods

Gilad has some spec language. He just needs to do a run through and get in
touch with Leaf about it.

### [#34 Allowing `super()` calls in mixins][34]

[34]: https://github.com/dart-lang/dart_enhancement_proposals/issues/34

People pointed out a few issues around warning verbiage that Gilad fixed, but
otherwise it looks good. We'll discuss it more when Kasper is back.

There is an [ongoing discussion][compose] on the repo there about mixin
composition, but we think that should be a separate DEP.

[compose]: https://github.com/gbracha/lessRestrictedMixins/issues/2
