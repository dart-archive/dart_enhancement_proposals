Attendees: [Bob][], [Gilad][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha

*Note: we skipped several weeks of meetings due to the [Dart Summit][].*

[dart summit]: https://www.dartlang.org/events/2015/summit/

Kasper was out this week due to some family commitments, so today's meeting
was, I suppose, 1/3 less official than other meetings.

## [Package spec][]

[package spec]: https://github.com/dart-lang/dart_enhancement_proposals/issues/5

We hoped to convince [Ivan][] to accept a restricted subset of Dart syntax for
the file, but were unable to. Instead, we'll go with the previous INI-file-like
syntax.

[ivan]: https://github.com/iposva-google

The remaining concerns for the proposal are what to name the file, and how the
proposal interacts with the language spec. The proposal has two options here.
Gilad's preference is to choose the option that says "package:" is
implementation-defined and remove the details of its semantics from the spec
entirely. He'll file an issue to that effect.

For the file name, there is an [open bug][file name] on that that we'll track.

[file name]: https://github.com/lrhn/dep-pkgspec/issues/10

This isn't blocking us from starting to implement the proposal in various
tools. We'll just change the file name later if we have to.

## [Spaceship operator][]

[spaceship operator]: https://github.com/dart-lang/dart_enhancement_proposals/issues/25

Kenneth filed a proposal to add a `<=>` to Dart that's synonymous with
`compareTo()`. Perl, Ruby, and Groovy have this.

The quality of the proposal itself is great: it's precise, lucid, and
semantically clear. However, we don't think the feature itself is a good fit
for Dart.

Unlike named methods, an operator can't be *read* to determine what it does.
Where a user may have never encountered `compareTo()` before, the words
"compare to" alone hint at what it does. If you've never encountered `<=>`
before, "less than equals greater than" won't help you much.

Also, each new operator introduces its own precedence and associativity rules
that users need to understand to visually parse code.

The rules of thumb I have for introducing an operator are:

1. It should be common from basic mathematics or other programming languages so
   that almost all readers will already be familiar with what it means.

2. It should be frequently-used enough make the brevity and more complex
   precedence table worthwhile.

The spaceship operator is familiar to users of a few languages, but not to most
(unlike, say `!` for negation).

Also, `compareTo()` doesn't seem to be used very often. In a corpus of pub
packages, I found 820 calls to `compareTo()`. There were 26x more uses of `<`,
13x more uses of `>`, and 73x more uses of `==`.

Given that, it seems like the right choice is to leave this out and keep the
language simpler.

## [Metaclasses][]

[metaclasses]: https://github.com/dart-lang/dart_enhancement_proposals/issues/4

This has been on the back burner for a while. In Kasper's absence, we can't
officially move it forward, but we spent some time informally talking about it.

Ian Hickson on the Sky team has brought the proposal up. Gilad's understanding
is that he was looking for the metaclass inheritance hierarchy to match the
regular class one. (In non-metaclass terms, this means roughly that
constructors and static methods would be inherited.) I believe Hixie was hoping
to avoid the headache of writing lots of forwarding constructors in derived
classes.

This is what Smalltalk does. It's one of the few corners of Smalltalk where we
deliberately want to do something different in Dart and *not* have metaclass
inheritance mirror the regular class inheritance. The Smalltalk way can be
convenient, but it's bad in principle since it can make the superclass's
factory interface leak into the subclass.

(In other words, if Derived inherits from Base, that doesn't always mean you
want the way you create a Base to be a valid way to create a new Derived.)

So the metaclass proposal doesn't cover Hixie's use case. Instead, Gilad has
asked him to try doing the work manually to see how painful it is.

### Static interfaces

The problem I had with the initial proposal is that it gave you a dynamic
object for the class, but didn't give you a way to statically type it. You
couldn't declare that the metaclass implements an interface.

Leaving that out of the proposal simplifies it, but it is a limitation. Since
then, Gilad has started to fill that in.

### Size

There is some concern that having metaclasses&mdash;effectively a pair of
classes for each class definition&mdash;will have some unwanted size problems
in the VM. This is especially a concern now that the VM folks are looking at
precompilation and are starting to care more about code size.

### Reification

The dev compiler folks (and I believe the VM folks too) have generally had pain
related to reified generics. They add a decent amount of complexity, use
memory, and don't always seem to provide much value in return.

I asked if metaclasses could help here.

Gilad said, yes, instead of using a reified *type* parameter at runtime, in
many cases, you could just pass the class in as a *value* parameter. There's
still the question of how the static type system sees it, so there's still some
complexity there.

But it simplifies the system: you don't have a parallel universe for passing
both value and type parameters around at runtime.

This would probably be a very long term change, but it might be nice to move in
the direction towards more stratification between the static and dynamic
behavior.

## [Interceptors][] and macros

[interceptors]: https://github.com/sigmundch/DEP-member-interceptors

Gilad talked to [Siggy][] about his interceptors proposal. Gilad would like to
work on a more general macro proposal that would subsume that. Siggy also
agrees that special-casing interceptors is a bit clunky.

[siggy]: https://github.com/sigmundch

Gilad is looking at the interceptors proposal then as a test case for a macro
proposal. If the macro proposal can cover interceptors, that's a good sign.
Even better, we can look at the full list of [transformers][] that Polymer and
Angular are using now and see which of those could go away if we had macros.

[transformers]: https://www.dartlang.org/tools/pub/assets-and-transformers.html

Gilad will get in touch with [Kevin][] to coordinate with this.

[kevin]: https://github.com/kevmoo

## [Static analysis of calls on functions][28]

[28]: https://github.com/dart-lang/dart_enhancement_proposals/issues/28

Lasse just filed this little proposal. Neither of us have looked at it yet, so
we'll kick it to next week.

## Configuration-specific code

There are a bunch of proposals floating around for this. After the summit, a
few of us on the Dart team spent some time talking about [Erik's
proposal][erik] and [external libraries][].

[erik]: https://github.com/eernstg/dep-configured-imports
[external libraries]: https://github.com/munificent/dep-external-libraries

Erik's proposal is a variant of Lasse's [configured imports
proposal][configured] that clarifies some of the static analysis questions of
the original.

[configured]: https://github.com/dart-lang/dart_enhancement_proposals/issues/6

External libraries is a strawman I sketched out which basically says, take the
"patch file" mechanism we are already using to handle the platform-specific
implementations of our core libraries (which need to bottom out at C++ on the
VM and JS in dart2js) and clean that up and make it generally available.

I'm obviously biased, but I think the idea got a warm enough reception at the
meeting that I'll spend some time trying to flesh out the details. If I can
find the time, I may experiment with implementing it in dart2js to see if it
works for the core libraries.

I'll also spend some time coordinating with Erik to see if the concerns he
raised with the proposal can be addressed.

### Linking to code-genned files

Another reason I'm interested in patch files is that they may help some of the
code generation tools we've been looking at lately. We're going in a direction
of using a tool to automatically generate code to implement things like
serialization for types.

That works well when the generated code is naturally in a separate file, but
works less well when you want to generate code into the middle of a
hand-authored class.

Patch files could address that too. You'd basically declare an external method
in your class and then codegen a separate patch file that fills that in.

## [Generic methods][]

[generic methods]: https://github.com/dart-lang/dart_enhancement_proposals/issues/22

Leaf's proposal is still ongoing. He's doing some work on it now.

Concurrently, the analyzer folks may start adding at least parser support for
it so we can start prototyping an implementation.

## Overloads

Jacob is working on consuming TypeScript definition files in dart4web, which
requires some way to handle TypeScript's notion of overloads in interfaces.
Since this is just for the web and the VM doesn't have to worry about it, it
may be fairly straightforward.

Gilad talked to [Jacob][] about it at the Summit. Since Gilad is busy right
now, we'll lean on Jacob to take a first stab at it.

[jacob]: https://github.com/jacob314

## Mixins

We have started discussions several times on lifting the restrictions on
mixins, but it hasn't been a priority in the past. I believe I've heard from
some customers recently about this so we may have some more reason to look at
it now. Gilad will write some details up about it.
