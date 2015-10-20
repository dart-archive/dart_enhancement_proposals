Attendees: [Bob][], [Florian][], [Gilad][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha

## Dealing with lazy compile errors

**Context:**

Natalie is working on the [test][] package. Obviously, it's important for a test
runner to be robust in the face of errors and failures in the tests. In
particular, it's important to reliably run the tear down code, even when an
unexpected error occurs in a test.

[test]: https://pub.dartlang.org/packages/test

For the most part, it does that by catching any exception that gets thrown, but
there is one case it currently can't handle.

The Dart VM handles reports syntax and compile errors lazily, only when the
method or function containing the error is first called.

Here's a Dart program:

```dart
badFunction() {
  look at this crazy syntax error!
}

main() {
  print("ok");
}
```

You might expect this to not run, but it actually prints "ok" and completes just
fine. The spec deliberately allows this because it improves startup time. The VM
can defer parsing, validating and compiling a chunk of code until the first time
it's actually used.

However, when a syntax error *is* found this way, it cannot be handled. If this
code is running in an isolate, the isolate is immediately aborted. This means
the test runner can't catch this and run the tear down code before the isolate
dies.

She'd like to be able to handle this more robustly. Her request is to be able to
catch syntax errors.

**End context**

Gilad's feeling is that if a test has a compile error, the user should notice
that (probably using the analyzer) and just not run the test at all.

Florian doesn't feel aborting the program or isolate is a good answer. We can
live with it, but it isn't the best solution.

I think the current behavior is wrong. If it's possible to execute some code in
a file in order to set up some state, you should be able to handle an error in
that same file in order to be able to restore the original state.

Gilad doesn't want to add more complexity to the language to handle this. Dart
is already in unfamiliar territory because of the way it lazily reports compile
errors. Being able to *catch* compile errors at runtime would put us in
uncharted waters.

It's a fairly rare issue. And it's easily avoided by just not running your test
if there's a syntax error in it, which the analyzer will be happy to tell you.

I do think the current behavior is weird. Most users aren't aware of it, and
those that are tend to be unpleasantly surprised. It reminds of me of C++
templates where you can have all manner of syntax errors in the template and you
won't know until you try to instantiate it. I don't think anyone is thrilled by
that feature.

I think the VM supports being run in "compile all" mode where it eagerly
compiles everything before starting. Maybe we could add that to the Isolate API
so you could start an isolate in that mode?

Florian would rather not expose a new API users have to worry about. He wants to
see how costly it would be to see if we can just get the VM to report syntax
errors eagerly (without necessarily *compiling* eagerly) and not run any code if
there is a syntax error.

Gilad and I think that's sensible too.

Over the long term, we may be able to get away from lazy compile error
reporting. It was important when we were aiming to get the Dart VM in a browser.
There, startup time is critical and you're running Dart directly from source.
Now that most Dart implementations have an explicit compile step anyway, it may
not be important to be able to defer reporting syntax errors.

Florian will talk to the VM folks about it.

## [Config-specific code][40]

[40]: https://github.com/dart-lang/dart_enhancement_proposals/issues/40

Florian has implemented the dynamic behavior in the VM and dart2js. He got the
OK from both teams to land those patches behind an experimental flag.

The remaining work on those platforms is the predefined environment constants.
He has a patch for them for dart2js but nothing for the VM yet. Before he works
on this, he'd like to change the proposal around them.

Right now, the proposal has a hard-coded list of "dart:" libraries and the
constants that get defined for them. Instead, he thinks the behavior should be
that each 'dart:' library an implementation provides gets a constant whose value
is `true`. This way, the proposal is open-ended to new Dart libraries in custom
embedders, like, "dart:flutter".

I'm all for that too. We'll tweak the proposal.

Now the big missing piece is analyzer support. Before we can even try it out, we
at least need phase 0 support&mdash;it needs to be able to parse the syntax
without freaking out.

Florian would like it to support phase 1&mdash;checking public
functions&mdash;before we start getting users to try it out. He wants to start
out with the most restrictive behavior so we don't commit to things we don't
need.

It's not clear to me that phase 1 has to be the most restrictive behavior.
Without actually checking public types for compatibility, we have two options if
a public type appears in an interface library: do nothing or warn. Doing nothing
means "Yeah, you can do this dynamically, but the static tooling can't help you
make sure you're doing it right." Always warning says, "This isn't even
supported."

Personally, I think it should not warn. I think it's OK for the static analysis
to not cover all things users can express dynamically. I don't think we'll get
good end user feedback that configured types are important if the tools try to
scare them away from even trying them.

Florian and Gilad feel it's safer to start conservatively. If the warning is
getting in their ways, users can let us know and we'll consider that a signal
that configured types are desired.
