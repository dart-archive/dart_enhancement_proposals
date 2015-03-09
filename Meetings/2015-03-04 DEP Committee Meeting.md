Attendees: [Anders][], [Bob][], [Gilad][], [Ivan][], [Kasper][], [Lars][], [Lasse][].

[anders]: https://github.com/anders-sandholm
[bob]: https://github.com/munificent
[erik]: https://github.com/eernstg
[gilad]: https://github.com/gbracha
[ivan]: https://github.com/iposva-google
[kasper]: https://github.com/kasperl
[lars]: https://github.com/larsbak
[lasse]: https://github.com/lrhn

## [Null-aware operators][]

[null-aware operators]: https://github.com/dart-lang/dart_enhancement_proposals/issues/9

Gilad has a [DEP out on GitHub][null] for this now. It adds three new operators
to Dart, each more wonderful than the last. All of them are syntactic sugar
with simple, completely local transformations to existing Dart semantics.

[null]: https://github.com/gbracha/nullAwareOperators

This is one of our oldest (#41!) and most highly-starred (103!)
[bugs][null bug], so we think people will like it.

[null bug]: https://code.google.com/p/dart/issues/detail?id=41

The careful eyes of the DEP committee noticed that the transformation for one
of the operators was wrong as was one of the examples. Nothing gets past us.
[Gilad has since [fixed it][fix].]

[fix]: https://github.com/gbracha/nullAwareOperators/commit/39a336b3fb8bb7b59cdba59f8f1a35b177fbd020

Gilad has spec language for this already. The main question is where it fits
into the grammar. That should be clear by the time someone writes a parser for
it.

A couple of corner case questions:

* Can `?=` be used in a constructor initialization list? **No.** Initialization
  lists don't allow any compound assignment operators. They're not just
  assignment; they have their own grammar production entirely.

* Can the Elvis (`?.`) operator be used with cascades? **No**, we don't have
  any plan to support that.

### Motivation

Erik brought up that we could add a motivation section if we want. It's
motivated by the philosophical perspective that if a thing is absent, then any
part of that thing is also simply absent as well. If you don't have a house,
you can't get to its door either.

I mentioned that I'm looking forward to `null` coalescing because it makes
field initialization simpler in many cases.

The Angular guys also want the Elvis operator. Previously, Angular templates
expressions treated all `.` operators like this. For Angular 2, they are moving
away from that to line up with Dart semantics. Having an explicit `?.` operator
will let users get that behavior back when they want it.

There's clear user demand for it and we're in agreement about the proposal. We
haven't formally accepted it just yet because we'd like to give the public a
chance to provide feedback. But, we expect we'll accept this at next week's
meeting unless something surprising comes up.

## Public DEP process

Speaking of which, during the meeting, others on the team flipped the private
bit and sent out the announcement making the DEP repo and the entire process
public.

## [Configured imports][]

[configured imports]: https://github.com/dart-lang/dart_enhancement_proposals/issues/6

Before we get into the details of the proposal, a high level framing question:
Should a program's configuration be able to affect the *static* shape of the
code, or just its runtime behavior?

[Remark from Erik: If we do want to consider something like the "static shape"
of an import, we ought to keep in mind that this concept is very similar to
that of a structure/functor *signature* in ML. If libraries were first-class
objects, they'd have classes, and they would in turn introduce library types,
and then we could declare the library type for each configurable import and
check that all the possible actual imports at that point do conform to this
library type. This is rather heavy, of course, which is the reason why I was
setting out from a simple, typeless model where there is no static shape
machinery, just a naive enumeration of all possible configurations.]

I think answering that helps guide us towards a solution. The two answers have
different consequences:

* If configuration can affect the static shape, then the analysis story gets
  more complex.

* If it can't, then awareness of configuration, and configuration-specific code
  gets pushed later into the runtime where we might not want it.

For example, the current patch file mechanism that the core libraries use
guarantees the same API across all platforms. This lets the analyzer see one
configuration for the core libraries.

This proposal is not like that. At *runtime* you will only ever import one of
them. That means warnings and what's malformed type are all based on what the
import resolved to. What goes into the namespace is based on what configuration
was actually chosen.

However, *tools* can see all URIs simultaneously. The proposal does make the
*set* of URIs statically known. It's not open ended, so the IDE can still see
all of them. But it has to try to "union" them together and see how they
overlap.

[Remark from Erik: There are different tools: A compiler should probably not
generate all variants in any setup with configurable imports (or any other
special case of software product lines), it typically accepts configuration
specifications ('-D') and compiles a single variant. "Partial compilers"
(dart2dart) might translate a program using conditional compilation directives
into an equivalent program using equivalent conditional compilation directives.
An analyzer might cover all variants simultaneously, either by iterating over
all variants internally every time it is relevant, or by some conservative
approximation (e.g., by just considering one "static shape" when all potential
imports have or conform to that same shape).]

For example, what happens if two configurations have a member with the same
name but different type? What does that do to auto-complete?

[Remark from Erik: This issue extends beyond typing and into semantics:
Considering an expression `x.y`, `x` might be a class or a variable name, and
`y` might be a static method name or an instance method or getter, so `x.y`
might be a getter invocation or a static method tear-off, etc.etc.]

The proposal lets you shoot yourself in the foot if configurations don't line
up. But it *does* give a real solution to the platform-specific code problem.

One option is that the IDE could ask the user to pick configuration and then it
analyzes the program in that context. That's what, for example, Visual Studio
does if you happen to use `#if` in C#.

Our concern is that then users end up committing code that only works in one
configuration because they didn't remember to check and test the others.

If all of the configurations expose the same API, everything works. But the
proposal doesn't *ensure* that, which is a concern. We want some feedback from
the analyzer folks about this.

An alternate proposal that floated around a while back was to just make all
"dart:" libraries available (but sometimes empty) on all implementations. So,
for example, you could successfully import "dart:html" on the standalone VM and
get the right types, but they would throw `NotImplementedError` at runtime if
you tried to call them.

Lars and others on the committee aren't a fan of that. It's nice to be able to
reliable strip code out that you aren't using. From Angular, we have some
experience that we can't rely entirely on tree-shaker to do this automatically.
It's good that this proposal lets you explicitly cut code out.

You can look at it like the C preprocessor in that it lets you statically
remove code, which is good for controlling what you deploy. But, then, it also
has much of the complexity of implementing an IDE for C that has to reason
about code that is using the preprocessor.

We ran out of time here, so we'll resume this next week. Stay tuned, folks
&hellip;
