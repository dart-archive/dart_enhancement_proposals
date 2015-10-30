Attendees: [Bob][], [Florian][], [Kasper][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[kasper]: https://github.com/kasperl

## Debug code

We're seeing interesting cases where users want to write code that only runs
during development. *(How the runtime determines that the user is "in
development" is an interesting secondary question, but we can probably assume it
roughly means "when checked mode is one".)*

Sometimes they use an `assert()` pattern like this:

```dart
bool debug = false;

void initDebug() {
  assert(debug = true);
}

void someFunction() {
  if (debug) {
    // debug only code...
  }

  // ...
}
```

Or they'll use a function expression:

```dart
void someFunction() {
  assert(() {
    // debug only code...
  });

  // ...
}
```

Neither one of those is great. Now that we're working on config-specific code
and setting up pre-defined compile-time constants, maybe we should set some up
to let users tell which mode they're running in.

This would let you do:

```dart
void someFunction() {
  if (const bool.fromEnvironment("dart.development")) {
    // debug only code...
  });

  // ...
}
```

That API is pretty ugly to use everywhere, so in practice, you'd more likely do:

```dart
const debug = const bool.fromEnvironment("dart.development");

void someFunction() {
  if (debug) {
    // debug only code...
  });

  // ...
}
```

This flag (or flags if we do more than one) would be set or not in parallel with
when assertions and checked mode is enabled. Then we just need to ensure that
the Dart implementations will reliably tree-shake away this dead code when
you're not in development. That should be doable.

We spent a little time talking about names. At the very least, we're going to
reserve environment constants starting with "dart." for the Dart team's usage.
That gives us room to expand to new flags in the future.

Right now we're leaning towards a name that directly reflects what runtime mode
it follows. Something like `dart.assertionsEnabled`, `dart.checked`, etc.
Florian will do some more work on it.

What this doesn't cover is cases where you want to have a development-only
*declaration*. Things like a field or class that only exists during debug.
Classes and top-level functions can be handled with config-specific code, but
something like fields are a lot harder.

Florian will nail down some more details and follow up with us.

## Handling syntax errors

Last week, we talked about a use case where the VM detects syntax errors in
methods after a file has started running. When that happens, it irrevocably
takes down the whole isolate. That makes it hard for the test package to
reliably perform teardown code if there's a syntax error inside a test.

One option we discussed is having syntax errors be catchable exceptions. Some
people on the team are worried about what the semantics are after that error has
been caught. What state is the library in? They would want some simple
guidelines. For example, "The body of a method that has a syntax error is
effectively replaced with `throw new SyntaxError()`."

It's relatively simple with functions and methods. But what about a syntax error
in a class declaration? That gets weirder. One option would to require the VM to
eagerly validate that classes parse before starting the isolate, but allow
method bodies to be parsed lazily. That might be a good trade-off of fast
startup while being able to handle syntax errors at runtime inside code.

We generally feel that the current behavior where the VM just hard aborts the
isolate isn't a good approach. It makes it very hard for users to write robust
software on top of that behavior.

I suggested that we get Natalie and someone from the VM team in the room
(virtually) when we continue the discussion since she's the main stakeholder
today and the VM team are the ones who would implement a solution.

## [Config-specific code][40]

[40]: https://github.com/dart-lang/dart_enhancement_proposals/issues/40

Last week, I updated the proposal to fill in the rules for [static checking of
public types][types]. Since then, I've been working with analyzer and DDC folks
to get a feel for how feasible those rules are.

[types]: https://github.com/munificent/dep-interface-libraries/blob/master/Proposal.md#phase-2-types

So far, they seem pretty simple and nonthreatening. Leaf managed to come up with
one interesting but complex use case that is hard to express, but I still have
to see if there's a workaround or if it's a use case that's important enough to
need to be made graceful.

Now that it's out, I'm eager to get more feedback on it, both from our type
system experts on the team like Lasse and Erik along with anyone else who is
interested.

## Meta-DEP

We've been doing these meetings for a while now, and it's a good idea to do some
reflection and see how we feel about the process and structure and if there are
any changes we want to make to them.

A big part of that is getting feedback from the Dart team and ecosystem about
what they like and don't like about them. We'd like to hear from you.

## Uninitialized locals and type inference

I've been playing with DDC's strong mode, and one case where it's tricky is
handling local variables with no initializer. Most of the time, it's best to
initialize them, but there are some patterns where that's hard. Often, it's
because the initial value is conditional on some expression, like:

```dart
var linesAfter;
if (i < comments.length - 1) {
  linesAfter = comments[i + 1].linesBefore;
} else {
  // More code...

  linesAfter = linesBeforeToken;
}
```

The easiest solution is to just type the local:

```dart
int linesAfter;
if (i < comments.length - 1) {
  linesAfter = comments[i + 1].linesBefore;
} else {
  // More code...

  linesAfter = linesBeforeToken;
}
```

But that's annoying if you want to have a consistent habit of using `var` for
all locals. It also isn't a viable solution for the parallel problem if
non-nullable types come into play.

Another solution is to hoist that logic into a local function:

```dart
countLinesAfter() {
  if (i < comments.length - 1) {
    return comments[i + 1].linesBefore;
  } else {
    // More code...

    return linesBeforeToken;
  }
}

var linesAfter = countLinesAfter();
```

But that can be cumbersome. Is there something better we can do? One option
would to make `if ()` an expression:

```dart
var linesAfter = if (i < comments.length - 1) {
  comments[i + 1].linesBefore;
} else {
  // More code...

  linesBeforeToken;
}
```

It would evaluate to the value of whichever arm was chosen. Likewise, a block
would evaluate to the last expression statement in the block.

Kasper said they considered something like that a long time ago for other
reasons, but it felt weird. In a language with C-style syntax like Dart, a bare
expression in statement position looks like a discarded value and it's
surprising to a reader when that's not the case.

A better solution might be to use flow-sensitive analysis to find all of the
assignments to the local and infer its type from those. That can get really
hairy in some cases, but for the common simple patterns like this, it might
work.

## Type promotion and pattern matching

In my code, I see a lot of code like:

```dart
if (foo.bar is Subclass) {
  var bar = foo.bar as SomeSubclass;
  bar.someMethodOnSubclass();
}
```

Our type propagation rules are very limited, so this double test-and-cast
pattern is annoyingly common. Can we do something better?

Florian's suggestion is that we should loosen the type propagation rules to
allow just about anything on the left hand-side. So the above could just be:

```
if (foo.bar is Subclass) {
  foo.bar.someMethodOnSubclass();
}
```

This isn't sound. There's no guarantee that `foo.bar` will return the same
object both times you call it. But if you look at the `is` check as an
expression of intent, it's reasonable for Dart to respect that. Johnni's wrote
[a thesis][thesis] proposing this for Java.

[thesis]: http://cs.au.dk/~jwbrics/papers/GuardedTypePromotion/

A safer option is to add some form of a pattern matching construct to the
language that lets you combine a type test and a conditional binding of a
variable.

For example, [C# is considering something][c] along the lines of:

```c#
if (foo.bar is Subclass bar)
{
    // bar is of type Subclass and only in scope here.
}
```

[c]: https://github.com/dotnet/roslyn/issues/206

A long time ago, I wrote a rough proposal for adding pattern matching to
`switch` statements. At the time, we didn't feel like it carried its weight.
Since then, it does seem like `is` tests are fairly common, so maybe it's worth
considering.

Florian would also like to consider supporting this at the function level in
much the same way that a function in ML or Haskell can be a series of pattern
matches. That would let you accomplish something akin to dynamically-dispatched
overloading in Dart.

Roughly like:

```dart
class CanvasElement {
  match {
    void drawImage(CanvasElement canvas) { /* Draw canvas... */ }
    void drawImage(ImageElement image)   { /* Draw image... */ }
    void drawImage(VideoElement video)   { /* Draw video... */ }
  }
}
```

These would all collapse to a single method for overriding purposes. There is
only one `drawImage()` method. It's more or less syntactic sugar for something
like this:

```dart
class CanvasElement {
  void drawImage(argument) {
    if (argument is CanvasElement) {
      var canvas = argument as CanvasElement;
      // Draw canvas...
    } else if (argument is ImageElement) {
      var image = argument as ImageElement;
      // Draw image...
    } else if (argument is VideoElement) {
      var video = argument as VideoElement;
      // Draw video...
    }
  }
}
```

This is more than just syntactic sugar, though. By pushing the type signatures
up to the method level, it would let static analysis do more precise
type-checking of these kinds of variadic method calls.

This would be helpful when working with the DOM, which uses overloads heavily.
(Which is a big part of why TypeScript [supports this][ts].)

[ts]: http://www.typescriptlang.org/Handbook#functions-overloads

## Suppressing warnings

We've had requests pretty much forever for programmers to be able to suppress
certain warnings in their code.

Let's start off with a (hopefully) simple question: how does a user write down a
suppression? There are a few options:

* Some kind of metadata annotation like `@SuppressWarnings` in Java.
* A special tool-recognized comment.
* A new language feature like some kind of `pragma`.
* In some other manifest file outside of the Dart code completely.

We're leaning towards one of the first two.

In the past, we've talked about removing the warnings from the language spec and
letting them be managed by the analysis team. I think how we decide this affects
how we do suppressions.

If we use an annotation for suppressions, that annotation class has to be
defined in some "dart:" library. That makes it pretty core to the platform is a
better fit if we also consider warnings core to the platform. If we move
warnings out into some separate annex, something like a comment feels like a
better fit to me.

Right now, our story is really messy with errors, warnings, and hints. Some
errors feel like they should be optional. Some warnings mean your program is
absolutely wrong and won't run. Some hints are super useful.

Part of the reason warnings are in the spec is because we have multiple tools
that implement them&mdash;dart2js, the analyzer, DDC. But, now that all of that
rolls up into dart4web, I don't think they need to be specified for those tools
to be aligned. Personally, I think the team can just sort itself out.

Others disagree. It's hard to decouple errors, which do need to be in the spec,
from warnings. Also, Fletch is a separate team and also reports static warnings.

The hard problem is going to be figuring out how the user identifies which
warnings to suppress. We'll need some sort of central database of all warnings
and hints with unique IDs for them. Getting that set up is probably where most
of the work will be.
