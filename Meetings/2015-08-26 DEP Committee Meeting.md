Attendees: [Bob][], [Florian][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## Proposal updates

Here's the proposals that are candidates for going into Dart 1.13:

### [Assert messages][assert]

Seth has [a proposal][assert] to add an optional message parameter to
`assert()` statements. It hasn't been formally submitted to the committee yet.

[assert]: https://github.com/sethladd/dep_assert_with_optional_message/blob/master/proposal.md

There are a couple of minor questions like:

 *  If the condition evaluates to `true`, do we still evaluate the message
    argument?

 *  Does the message have to be a string or can it be any object (and we
    implicitly call `toString()` on it)? Gilad thinks it should be a string to
    get some kind of type-checking.

Florian brought up an alternative to the proposal: put a Dartdoc comment before
the assertion and have tooling able to find that and show it. I said you can do
that now manually based on the stack trace. The nice thing about messages is you
can do interpolation at runtime and have a more precise message: "The value
should be less than 11, but you passed 42.".

Overall, though, we think the proposal is fine and it would be nice to move it
forward. The next step (and the process we want to use in general going forward)
is to do an experimental implementation. Then, if that goes well, we'll move
towards accepting it.

I've filed a [tracking bug](https://github.com/dart-lang/sdk/issues/24213).

### [#28 Static analysis of calls on functions][28]

[28]: https://github.com/dart-lang/dart_enhancement_proposals/issues/28

This is accepted, and we think the implementations were already doing the right
thing. We want to be able to officially declare it in Dart 1.13, so Florian will
check and make sure the implementations are all doing the right thing.

Gilad has discussed it with TC 52, and we expect they will agree with it too.

### [#3 Generalized tear-offs][3]

[3]: https://github.com/dart-lang/dart_enhancement_proposals/issues/3

This has been approved by TC 52. The VM has shipped them and is the only
implementation that has. There's been no priority yet for implementing it the
analyzer and dart2js. Florian will talk to the relevant people and make sure
something happens.

The proposal went through because Lars really likes it. It's been voted on, so
we need to implement it or do something about it. We can't leave it in limbo.

If we don't think it's the best thing for Dart users and the Dart project, then
changing it is probably a 2.0 thing.

### [#34 Less restricted mixins][34]

[34]: https://github.com/dart-lang/dart_enhancement_proposals/issues/34

The DEP has been accepted but hasn't been to TC 52 yet. We don't expect there
to be any changes, so we should just finish implementing it. The VM already
has. Florian will follow up with the relevant people.

## Changing the meeting

Florian proposed we broaden the scope of this meeting to be more proactive about
driving the evolution of the language. That also means we'll make it longer: one
hour.

In that time, we'll go over proposals but also actively take on subjects that we
think can make Dart better. In other words, more like the old "language
meetings" we used to have.

## Dart 2.0

In particular, as we start talking about Dart 2.0, we need a form for longer,
more open-ended meetings. As a starting point, in the next meeting, Florian
would like to discuss what things we think could or should be removed from Dart
in 2.0.

We need to start doing these discussions and stop tiptoeing around Dart 2.0 if
we want to get there in a reasonable amount of time. We may have disagreements,
but we need to work those out. We need to find the common ground among our group
to see if there is a single "Dart" that we are all excited about.

## Nullable types

Florian started a discussion about whether we think a nullable type should be
assignable to a non-nullable one. In other words, can you *implicitly* "cast"
the nullability away.

Personally, I don't it should be allowed. Assigning a value that may be null to
a variable that never expects one is exactly the point in my code where I want
the type checker to draw my attention, is the likely place where bugs may occur.

But, playing Devil's advocate, this is incompatible with our regular notion of
assignability. Dart allows implicit downcasts in general based on the philosophy
that the assignment *may* often work (the variable often is the right subclass
even if we only statically knows it's a superclass). Likewise, a nullable-typed
variable often does have a non-null value, so an assignment to a non-nullable
type will often work.

I agree that disallowing assignment from nullable to non-nullable types is
inconsistent with implicit downcasting, but I also don't like implicit
downcasting. I'd rather get rid of that than make non-nullable assignments
looser.

Of course, this would be a 2.0 kind of change.

## Soundness

This leads to a larger discussion about soundness. Gilad has always liked
optional typing, but never felt that the optional type system itself should be
unsound. There is a point in the design space where you have an optional type
system but where you do use it, you are sound.

The type system already has an escape hatch: it's optional. If you've opted *in*
to using it, we don't need more holes *within* that.

Generics is another pain point with unsoundness. Making those sound would be
very difficult. Florian feels that making generics invariant would be too
difficult to work with.

Gilad discussed with Philip Wadler one point in the design space: Make generics
invariant and whenever you need polymorphism, make a generic method. Gilad
feels that may also be painful. But, personally, I worked in C# 2.0 for several
years writing lots of generic code in exactly this way and always found it
pretty pleasant.

Gilad thinks invariant generics might be worth reconsidering if we can provide
a much better tooling experience. It's not helpful if the user just gets an
error when they try to pass a `List<int>` to something that expects to read
from a `List<num>`. But, say when you wrote a method that took a list and only
read from it the tool would pre-emptively suggest you make the method generic
with a `T extends num` type parameter" and offerred to fix it for you on the
spot, that could be a lot better.

## Splitting the spec

Florian brought up the position that the type system could be pulled completely
out of the core Dart specification. As long as the syntax lets you write all of
the annotations you need, the (or a) type system could be a separate tooling
feature. For example, DDC has its own set of type rules that it enforces.

As long as Dart is expressive enough to let you write a program that *could* be
soundly checked, we could leave it up to separate tools to define that.

My feeling is that the set of people who can design and implement a sound type
system is pretty small. If we're going to do half the work to ensure the
annotations are expressive enough, we're probably the best people to just design
and implement the whole thing.

Gilad brings up that we still could be the ones to provide it. Even then,
having a layer of separation between the core language and the type system
gives us more freedom. In the same way that it's easier to hack on pub because
it isn't fully-specified by the language, it would be easier to iterate on the
type checking rules if they aren't baked into the language spec.

This suggests we would split the spec in two: the dynamic and static behavior.
The two would evolve at their own rate. The former likely more slowly than the
latter.

Checked mode makes this much more complicated. Once you have a type system at
runtime, you have some obligation to be coherent with your static one. My
feeling is that if you have a sound type system, checked mode may not be as
valuable anyway.

It's still useful given that data can move in and out of dynamically typed code,
so type errors may appear at runtime that can't be caught statically. But, if
the type system is sound, and you stay within fully typed code, you know there
won't be type errors at runtime. Maybe checked mode doesn't add much value
beyond that. Florian believes it is still important for catching bugs.

Gilad brought up that we could recast the idea of checked mode into something
that feels less like a type system and more like a flexible assertion system.
They wouldn't have hard-wired assumptions about the full Dart type system. It
would be nice to be able to only run parts of your program in checked mode. If
we look at these as assertions that can be injected, and if we avoid ratholes
like generics in checked mode, there may be a good story.

Generics in checked mode is what led us to reified generics, which in turn
causes other complications for us with the type system and things like type
inference.

Personally, I've never found once reified generics useful in Dart, though
Florian does feel they catch bugs in checked mode.

*Erik notes that you could also have a variant where generics are reified in
checked mode but not in production mode, and `is` and `as` cannot rely on
them.*

I do worry that separating out the static type rules from the dynamic semantics
may cause us problems down the road. If we want to make Dart really successful
on small-power, small-memory embedded devices, that naturally leads towards
value types. Those may be harder to design if the static type annotations are
very separate from the runtime behavior. (In other languages, declaring a
variable as `int` dictates both its static type, and its storage
representation.)

Gilad feels this won't be a problem, but we ran out of time to discuss it
further.
