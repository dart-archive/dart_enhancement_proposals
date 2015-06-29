Attendees: [Bob][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

### [#34 Allowing `super()` calls in mixins][34]

[34]: https://github.com/dart-lang/dart_enhancement_proposals/issues/34

We're there! It works in the VM. All of it works out of the box. There was a
worry about how generic parameters are copied up, but it's working fine.

We got some comments on the spec from Lasse and Erik, and Gilad has addressed
them.

Kasper talked to Lars about mixin composition. We're worried about promoting it
too much since it reintroduces many of the problems of multiple inheritance.
But mixin composition is separate from this proposal anyway so we're fine.

The proposal is accepted!

### [#28 Static analysis of calls on functions][28]

Gilad has a draft spec that Lasse has reviewed and it's all there, so we're
good. This is now accepted!

[28]: https://github.com/dart-lang/dart_enhancement_proposals/issues/28

### [#32 Metadata for type annotations][32]

[32]: https://github.com/dart-lang/dart_enhancement_proposals/issues/32

We're sympathetic to the high level notion. In principle, metadata should be
allowed anywhere in the AST. That's tricky with Dart's syntax in many places,
but allowing it anywhere you can put a type annotation is fine.

This proposal goes farther and allows it in other places where types may appear
in expressions. We don't have a mechanism to deal with that, since our APIs are
designed around annotations appearing on declarations.

Putting them elsewhere complicates the picture. Right now, the VM assumes it
can avoid parsing metadata annotations until they are actually requested
through mirrors. That's possible because we can associate the metadata with a
static place in the code. If we allow metadata on *values*, that gets much more
complicated.

Having said that, we are interested in the part of the proposal for extending
metadata around type annotations. We'd like the proposal to be scoped down a
bit.

After that, we're interested in taking a look with that caveat that it may not
be a high priority right now so it may take a while before we get to it. We
want to control the workload we throw onto the implementors.

## Configuration-specific code

I'm working on revising my ["external libraries"][ext] proposal for handling
configuration-specific code. I am expanding it to cover things such as the SDK
extensions like the Sky team wants to do.

[ext]: https://github.com/munificent/dep-external-libraries

My goal is to subsume patch files and hopefully `native` keyword the
implementations currently use, as get to a single system that covers our
internal use cases and is clean enough to let external people like the Sky
folks and people who want to do configuration-specific libraries use.

One of our current challenges with SDK extensibility is that the VM has its own
way of defining native behavior that isn't specified and causes grief for our
other tools. But that syntax isn't actually very different from the `external`
keyword in the spec. So it may be possible to either use a metadata annotation
on an external function or add an optional string literal to `external`.

Fletch and dart2js use metadata annotations for this. They annotate functions
with a special marker annotation defined in some internal library. Some of
these functions have no body and some do have bodies that are used as
fallbacks.

Using a string literal instead of an annotation feels a bit artificial. Since
the places where this will be used will generally be in internal libraries that
are in the VM's snapshot anyway, it may not be necessary to prematurely
optimize by adding special syntax.

Either way, the proposal covers both options.

The trickiest part of the proposal is specifying how an external library is
patched into the canonical library. The proposal takes a stab at that, but it's
still kind of informal, likely wrong in places, and will need some iteration.

I also need to work with the other stakeholders that are invested in some of
the other proposals. This one may not solve all of the use cases that some of
the other proposals can handle. I think this one covers most of Lasse and
Erik's proposals, but may not be as expressive as Natalie and John had in mind.

It will be up to me to work with them and try to get to a place where they're
all happy. The nice thing about this proposal is that it has an existence proof
of its utility, since it's effectively what we already use now for our core
libraries.

## [Non-nullable types and non-nullable by default][nnbd]

[nnbd]: https://github.com/dart-lang/dart_enhancement_proposals/issues/30

Patrice has an update to his proposal that includes a partial implementation.
We haven't had time to look at it in detail yet.

On our end, we have a syntax in mind for the annotations (postfix `!` and `?`).
Now we need to start implementing parsing support. We'll do this behind a flag.
That lets us make progress while still letting us pull it out later if it
doesn't work out.

## [Null-aware operators][]

[null-aware operators]: https://github.com/gbracha/nullAwareOperators

The VM folks have brought to light a few corner cases as they've begun
implementing this that Gilad would like to tweak the spec to address. Some
cases are minor like difference between `super.?(...)` (disallowed) and
`this.?(...)`. We allow the latter because `this` is just an expression even
though it can never be `null`. (Well, outside of the `Null` class that is.)

The interesting one is:

```dart
SomeClass.?staticMethod();
```

According to the current specification, the left-hand side of `.?` is an
expression, so we treat `SomeClass` as an expression that evaluates to the type
object. That isn't `null`, so then we call `staticMethod()` on it, which likely
won't be found.

Should we handle this specially like static calls elsewhere so that
`SomeClass.?staticMethod()` looks up the method on the class when the left-hand
side is a class?

This problem would go away if we adopted [metaclasses]. In the meantime/absence
of that, what should the behavior be? We don't think this will come up in
practice much anyway. Users shouldn't do this in general, but if they *do*, the
most obvious thing for users is for it work like static calls.

[metaclasses]: https://github.com/dart-lang/dart_enhancement_proposals/issues/4
