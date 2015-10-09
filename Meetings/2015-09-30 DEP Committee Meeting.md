Attendees: [Bob][], [Florian][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## Leads meeting

Last week, a bunch of the leads on the Dart team met to strategize or whatever
it is leads do. One interesting outcome of it is that we're going to give each
of the teams that owns a Dart implementation&mdash;the VM, dart4web, and
Fletch&mdash;more leeway in what they support. They have the freedom to ship
something that works for their platform but may not be supported on the other
ones.

For example, the Flutter folks, and the Dart VM team supporting them, are going
to do what they need to make their product successful. We've seen the same thing
in dart4web and Fletch.

In many ways, this is what we've always done. For example, there was never any
real plan to support big integers in dart2js even though the language specifies
it. Now we don't have to feel as guilty about that.

This makes our job on the DEP committee harder. We're focused on the core
language that is shared across those implementations and we want to maximize the
size of that. There is still a ton of benefit to being compatible across
implementations and being able to reliably share code.

Our task is to improve the overall language in ways that all of the
implementation teams are excited about. In some ways, they're our customer.
Meanwhile, they may come up with something that makes sense for them but not the
other implementations. We can try to generalize it to something useful across
the whole system, or help them, or let them do it on their own.

The boundary of what is truly shared and compatible across all implementations
is fuzzier now. It's kind of alarming, but it's probably a good thing. Dart is
mainly a client-side language. When you run on the user's hardware, you need to
have a high affinity to it to work well and perform efficiently.

Languages that succeed there tend to be chameleonic and adjust their colors a
bit based on what they are running on. This is why C has undefined behavior, and
why Java server, GWT, and Android all treat Java a little differently. The
platforms are divergent, so it makes sense for the language to be a little
divergent too.

Having said that, we really get the value of being able to share code *across*
platforms, so our goal is to minimize fragmentation while still letting the
implementation teams be successful.

## [Config-specific code][40]

[40]: https://github.com/dart-lang/dart_enhancement_proposals/issues/40

We have agreement on what we want to try to implement, but we haven't started
yet. Florian has some time, so he's going to get started. I want to as well, but
I've been busy so haven't had a chance yet. He'll let me know what he starts on
so we don't step on each other's toes.

## [Assert message param][37]

[37]: https://github.com/dart-lang/dart_enhancement_proposals/issues/37

There's an open question. Does the parameter have to be a string, or can it be
any object that is coerced to a string?

A while back, I emailed the DEP folks suggesting it should allow any object by
comparison to other language features:

* It's consistent with `print()`, which allows any type.
* It's consistent with `throw`, where the VM calls `toString()` on the object
  and shows the result when displaying the stack trace.
* It's roughly consistent with `if` and `while` which allow non-boolean types in
  production mode.
* It's consistent with `await`, which allows non-Future arguments and implicitly
  converts them to futures.
* It's consistent with interpolation which calls `toString()` on the
  interpolated value.

Gilad didn't find that convincing and prefers it to be a string, though he
doesn't care that much either way.

Florian suggested instead of coercing immediately, just store the original
object in the AssertionError. When you display the error, it would get
`toString()` called on it then. That would let you inspect the actual object in
a debugger.

Kasper said this was good and general, but how much actual value does it add? If
you want to have an error with an interesting object, why not throw an
exception?

Insisting on a string may lead to better tooling. We could maybe do better
auto-complete for that parameter if it know it's a string. If it's really
uncommon for it to be any other kind of object, guiding the user can be helpful.

Florian thinks allowing any object is simpler to spec.

Gilad said most people he talked to do seem to prefer it to allow any object,
even though he thinks that's more likely to cause mistakes than yield real
benefit. But he would be happy to change it if that's what the committee
decides.

Most of us don't seem to have a strong opinion one way or the other, so Florian
made the deciding call to stick with a string.

## [Improved default constructors][ctors]

[ctors]: https://groups.google.com/a/dartlang.org/forum/#!topic/core-dev/cQZlx90c7z0

Lasse had an idea for extending the default constructor. Instead of no
parameters, it would get a named parameter for each field in the class. That
would let you define a class like:

```dart
class C {
  int foo;
  final int bar;
  int baz = 42;
}
```

Which you could then construct like:

```dart
new C(foo: 42, bar: 10)
```

It's a neat idea. It became more interesting lately because I've been reviewing
a lot of internal Dart code in Google. I see a ton of code that creates objects
like this:

```dart
new Address()
  ..street = (new StreetAddress()
    ..number = 123
    ..street = (new Street()
      ..name = "Main"
      ..kind = "St."))
  ..city = "Springville"
  ..state = "Illinois";
```

I don't have a lot of context when doing these reviews, so I'm not sure exactly
why they do this. Sometimes it's because these types are coming from
[protobufs][], but I see this even in hand-authored sites.

[protobufs]: https://github.com/dart-lang/dart-protobuf

Aside from the verbosity and general strangeness, note that this means all of
these fields have to be public and mutable.

I wonder if we had Lasse's suggestion, if people would use that instead:

```dart
new Address(
    street: new StreetAddress(
        number: 123,
        street: new Street(name: "Main", kind: "St.")),
    city: "Springville",
    state: "Illinois");
```

Gilad doesn't like constructors to begin with, so he's not keen on adding more
to them. They are already very complex and even adding something like this may
not prevent this kind of problem.

I offered to sketch out a proposal if the committee is interested, after I free
up some time. But first, I want to do some more investigation about the code
that uses lots of cascades to get a better picture of why they're doing it that
way.

It's true that constructors are already very complex (initialization lists,
const, redirecting, factory, initializing formals, etc.), so we don't want to
add anything else unless we know it actually helps.
