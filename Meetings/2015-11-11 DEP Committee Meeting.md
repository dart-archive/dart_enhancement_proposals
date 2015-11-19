Attendees: [Bob][], [Florian][], [Gilad][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha

## [Assert message param][37]

[37]: https://github.com/dart-lang/dart_enhancement_proposals/issues/37

Strangely enough, we are still discussing the dark corners of this. The open
question now is what happens if an exception is thrown when evaluated the
message argument.

Consider this (completely contrived) example:

```dart
assert(shouldBeTrue, "This will fail: $doesNotExist");
```

Should the user get:

1. An `AssertionError` describing the `NoSuchMethodError`.
2. The `NoSuchMethoderror` itself.
3. An `AssertionError` for the failed assertion ignoring the fact that the
  message threw.

My feeling, which I think I've at least convinced most people of, is that we
should do #2. If there is a bug in your assertion message code, you'd really
like to fix that bug. It's no fun having bugs inside the code you use to detect
other bugs!

If we make the fail look like the assertion itself has failed (which itself
implies some *other* bug), then the user may not realize the *message* failed
too. In that case, they may fix the code causing the assertion to fail. Once
they do that, the code for the message no longer gets evaluated and they won't
know there is still a bug lurking in there.

I think it's better to draw attention to the message failure so that users fix
that *first*.

One way to get this behavior is by specifying `assert()` in terms of an explicit
constructor call to `AssertionError`. We don't think this is a good idea because
it limits how the VM can report assertion failures. Right now, it doesn't just
desugar `assert(condition, message)` to something like:

```dart
if (!condition) throw new AssertionError(message);
```

Instead, it adds some extra data to the AssertionError object like the source
text of the condition. That stuff is helpful for a user. Specifying that the VM
*must* call a certain constructor prevents that.

Most of the discussion around this has happened on a [code review][] that
Florian didn't see, so he'll catch up on that and follow up on it.

[code review]: https://codereview.chromium.org/1324933002/

## Handling syntax errors

We've [discussed this before][syntax].

[syntax]: https://github.com/dart-lang/dart_enhancement_proposals/blob/master/Meetings/2015-10-28%20DEP%20Committee%20Meeting.md#handling-syntax-errors

We feel that if the body of a function has a syntax error, it would be good if
it was possible for a user to be able to handle that at runtime. This lines up
well with the idea of a live editing experience where users can patch and
replace methods on the fly while the system is running.

You could imagine treating it like any function whose body contains a syntax
error has its body implicitly replaced with `throw new SyntaxError(...)`, which
is pretty straightforward. But, after talking to the VM team, it seems like
there is a bunch of complexity hiding in the problem. There are cases where it
can get weird.

Likewise, there are syntax errors that are likely not recoverable. Things like
errors at the level of a class declaration or at the top level.

Florian is going to spend more time talking to the VM team about it.

## [Config-specific code][40]

[40]: https://github.com/dart-lang/dart_enhancement_proposals/issues/40

Florian has a patch for the VM, but the VM team doesn't want to land it without
analyzer support in place. Florian started a patch for the static analysis then
discovered the analyzer folks are already working on it themselves.

They have support for the syntax now. The static checking hasn't been
implemented yet. We could land this without the static checking and hide the
feature behind a flag, but Gilad and Florian would rather have some checking in
place first.

The analyzer folks have been thinking pretty deeply about the static checking. I
get emails every few days asking clarifying questions about increasingly deeper
and darker corners of the semantics.

They are definitely finding interesting consequences, but so far nothing too
alarming has shown up as far as I know.

They have some process challenges around how to land these changes. Because the
analyzer is used both by internal tools *and* has a public library API, "behind
a flag" isn't very well-defined. If they change the AST classes, that's part of
analyzer's public API.

## "Non-controversial" changes

Florian brought up a few micro-scale language changes that he's interested in
and that he thinks are fairly non-controversial (though maybe not *all* of them
are).

*   Allowing `_` inside number literals. Other languages allow this to group
    digits, like `1_000_000_000`. Easy to add and kind of nice.

*   `0b` for binary number literals.

*   Incomplete surrogates in string literals. You can manually build a string
    that contains these, but there's no literal form for them.

    Given that some implementations are talking about changing their string
    encoding and given how string encoding issues always seem to be a rathole,
    this may be controversial.

*   Removing the need for nested `const` qualifiers. This one already has [a
    proposal][const].

[const]: https://github.com/lrhn/dep-const/blob/master/proposal.md

We spent a little time discussing scope and priority of language changes. The
vibe is that in the DEP process we don't seem able to make changes that are
large in scope. But the kind of small-scale changes we can make are
correspondingly small in *impact*.

Even very small changes seem to have a surprisingly large implementation cost,
so it's not clear if that's what we want to spend resources on right now. Would,
for example, we rather have the team implementing for binary
literals&mdash;including parser support in the analyzer, dart2js, VM, syntax
highlighters, tests, specification, etc.&mdash;or should we spend that time
doing things like making analyzer faster or adding VM features the Flutter folks
want?

## Assertions in const constructors

Florian doesn't have a proposal, but users have asked for the ability to have a
body in const constructors only to contain asserts so you can do some validation
of the state of a new const object.

From talking to users, his impression is that users are reaching for const
because they really want immutable objects. So maybe the real problem we should
be tackling is explicitly supporting objects that are deeply immutable after
construction.

This would, for example, make it easier to be able to send these kinds of
objects across isolates.

We ran out of time, but this is something we'd like to talk about more.

