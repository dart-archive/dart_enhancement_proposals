Attendees: [Bob][], [Florian][], [Gilad][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha

## Dart 2.0 product and language strategy

We're starting to talk about Dart 2.0 at the language and platform level, but
meanwhile, our project manager ~~overlords~~ friends are just beginning to have
similar discussions at the product level. What kinds of applications and users
do we want Dart 2.0 to cater to?

As we have these language discussions, I want to keep those product and user
requirements in mind. We can't get ahead of the PMs but we have a rough idea of
where we&mdash;the people in this meeting&mdash;think it's going.

 *  Dart 2.0 is aimed at client-side mobile applications first.

 *  Client side web applications are still important, of course. Our internal
    and external web users are the ones paying the bills and we want them to be
    happy.

 *  We want to support server-side apps too. After all, many of our own
    command-line tools are written in Dart. But servers don't generally place
    as many hard constraints on a language so we don't have to worry too much
    about this when it comes to guiding language decisions. If a feature works
    well on a mobile app, it will probably be OK on the command-line too.

Most of the language changes we're talking about are probably not affected by
this. Stuff like tweaking the syntax doesn't matter where the code runs.

One thing that's up for discussion is very closely related to this. Users
generally like Dart's rich core libraries, but we're having real problems
getting them to fit on some 200k IoT device. We don't want to cut features, but
we want to be able to shrink things down more. There may be language or library
changes that could help here.

## Static checking for dropped futures

Florian has seen a very common problem that he'd like our tools to be able to
help the user with. If you call a function that returns a future and you don't
return or await on it, this is almost always a bug. It's an easy, common
mistake to make.

Should it be a warning or a hint? If it's a warning, then getting it changed
means a DEP, the DEP committee, TC 52, etc. For a hint, we can just file a bug
and add it. The latter is way more efficient, so Florian will just ask for it
to be a hint.

Even as a hint, we still want to ensure users can deal with false positives.
There are some times where you do deliberately discard a future and we need some
mechanism where users can make the hint go away there. (One obvious example is
`main()` itself.)

You can't just assign the future to a thrown away variable since then you get
an unused variable hint. So we'll need to come up with some little mechanism
for this.

## Config-specific code

We have it down to a couple of possible proposals. All of them are tolerable so
it's down to figuring out which one makes the best trade-offs. Soon, we'll get
Kasper to cast his vote if we need a tie-breaker.

I believe Florian, Lasse, and I are happy with the "interface libraries"
approach. (I would link to it, but we don't have a fully written version yet,
just lots of email and shared understanding.) Erik would still prefer something
simpler. We have a meeting later this week to talk about it more.

The interface library proposal starts to sound similar to first-class
libraries, so we talked about whether that may run into some of the same issues
as those.

Gilad says it depends on how precise we want the type-checking to be. If we
want to be fully sound... basically no one knows how to do that. It's doable
without inheritance. Part of the challenge is being to express the capabilities
of a class in a library interface: can it be extended, mixed in, etc.

One proposal side steps this by only allowing static functions in the library.
We could start there and then extend it to allow configuring classes.

The key question is do we want to allow inheriting types from configured
libraries? Given that we have users who very much want to be able to write a
server-side wrapper for "dart:html" and custom elements (i.e. user classes that
extend `Element`) are a thing, it seems the answer is "yes". This isn't a
common case&mdash;most code doesn't inherit across library/package
boundaries&mdash;but it is an important one. There are probably other similar
cases in Sky.

By this point, it seems like we've done a brute force search over the solution
space. We've got a couple of local maximas. Gilad will read up on the proposals
and then we'll talk about it more next week.

## The chopping block

We started going through our lists of Dart features we're interested in
removing in Dart 2.0, starting with Gilad's list.

I want to stress very clearly **that this is a brainstorming exercise, and not
at all any kind of plan, commitment, or necessarily even a desire felt by a
majority of the team.** We're just talking informally around the idea of what
Dart 2.0 *could* be, not what it *will* be. Think of these as a wishlist for
Santa.

Expect to see the same caveat in all of the meeting notes for a while. We think
it's important to do the design in the open so we can get feedback, but it means
understanding that all of this is tentative and subject to change.

### Reified generics

Gilad suggested removing reified generics would be contentious, but we are
actually all interested in this. We think there's traction on removing it from
production mode. The open question is whether it should be removed from checked
mode too. There are some who would like that too, but Florian is currently
against it.

### Type tests

Gilad suggests removing the baked in semantics for type tests and replacing
them with method calls. In a "pure OOP" language, the only thing that matters
is how an object behaves&mdash;what it does when you call methods on it. Type
tests break that since an object can't control how it responds when you use it
on the left-hand side of an `is` expression.

This bites us when people try to do things like create classes that can
dynamically masquerade or proxy some other class. Those fail in checked mode
because the proxy can't "cheat" the type test and pretend to be another type.

Instead, we could make type tests be method calls on the object. When you
define a class `Foo`, it implicitly declares an `isFoo` method that returns
`true`, while `Object` automatically gets one that returns `false`. A type test
is just an invocation of that.

Proxies would override that explicitly to return `true` for the types they want
to emulate. Likewise, checked mode would use this for its type validation,
which gets us closer to the idea that "checked mode" is a contract or assertion
system.

Florian and I have some issues with this:

 *  We don't find the use case that compelling. Some users have wanted to be
    able to create dynamic proxies, but it doesn't come up that often.

 *  This doesn't work with type tests for generic types. If we get rid of that
    anyway, this is probably OK.

 *  This can make static analysis less reliable. Things like type promotion and
    type inference presume that a type test on an object only returns `true` if
    the object does reliably implement that class's interface. But a custom
    type test method could lie, or even return different values over time.

    Gilad's feeling is that users doing that would be crazy anyway, so it's not
    something we have to worry about.

 *  This will make static compilation, separate compilation, and tree-shaking
    harder. Without seeing the whole program, you don't know which classes
    override the type test methods.

### Type annotations on the right

This is not a really a *removal* but Gilad brought up making type annotations
follow the variable name after a colon, "like civilized languages". In other
words, instead of:

```dart
String name;
final int pi = 3; // Close enough.

bool hasTwo(List elements) => elements.length == 2;
```

You would write:

```dart
var name : String;
final pi : int = 3; // Close enough.

hasTwo(elements : List) : bool => list.length == 2;
```

This makes declarations much easier to parse. It would also make it possible to
have a function type syntax that can be used anywhere. Currently in Dart, it is
impossible to declare a field whose type is a function since it clashes with
method syntax:

```dart
typedef void Callback();

class Observable {
  void observer(); // Oops, looks like an abstract method.
}
```

You instead have to use an awkward typedef:

```dart
typedef void Callback();

class Observable {
  Callback observer;
}
```

Making the type annotation syntax more clearly isolated in grammar fixes that:

```dart
typedef void Callback();

class Observable {
  var observer : () -> void;
}
```

All of us see the appeal, but we expect it would (will?) be a difficult change
to push through. However, it does add real value. In addition to the above, it
makes it easier to allow [metadata annotations][] on any part of a type
annotation, something we've wanted for a while.

[metadata annotations]: https://github.com/dart-lang/dart_enhancement_proposals/issues/32

It also clarifies Dart's optionally typed nature. Currently a type "annotation"
also is implicitly a variable declaration:

```dart
int i;
```

Here, you can't *remove* the `int` type annotation because that also removes
the variable declaration. It's not really an *annotation* at all. But with this
syntax:

```dart
var i : int;
```

It's very clear that `var` (or `const` or `final`) is always used to create a
variable, and the annotation is always a separate, optional construct.

### Static methods

Instead of explicit static methods, Gilad suggests we make them instance
methods on class objects. In other words, do [metaclasses][] like Smalltalk,
Ruby, and others do.

[metaclasses]: https://github.com/dart-lang/dart_enhancement_proposals/issues/4

Florian is worried about how it affects tree-shaking. When a class becomes
first class, you have to track when it gets passed around and determine when
its static methods may be being invoked dynamically.

When Kasper looked at the metaclass proposal, his feeling was that it wouldn't
have a big effect on dart2js's output, though that presumes users continue to
use static members as they do today. If people starting passing around
metaclasses and doing dynamic dispatch on them more, it's unknown what kind of
impact that will have.

### Constructor initialization lists

Dart achieved a rare goal in object-oriented languages in that it ensures that
all of a class's fields have been initialized before `this` is visible and
virtual methods can be called on it. Java and C# don't do this.

Dart gets this by having constructor initialization lists. But we aren't sure
they're worth it. The problem they solve is not that much of an issue in
practice, and the feature adds a lot of limitations and complexity.

You either have to cram all of your initialization into either a single list of
expressions, which can be hard to read, or you have to make a separate factory
constructor, which is verbose and tedious.

We could either eliminate constructor initialization lists and simply not worry
about virtual calls before all fields are initialized like Java and C# do. Or
Florian mentions that other alternatives exists and have been discussed, like:
the `super()` call goes in the body of the constructor, and you cannot access
`this` until after that call.

This would split your constructor into two sections where `super()` is the
dividing line. It might be a bit confusingly magical, but it would allow more
complex statements and control flow while initializing fields. It might be
surprising but it's probably more usable once you know it.

However, removing initialization lists would be difficult because they are so
tied to const classes. The obvious suggestion is to remove const too...

Const adds a lot of complexity to the Dart language, and it doesn't provide
that much value in return. It is useful for some things, but does it carry it's
weight?

### Parts

Gilad and I would like (love?) to get rid of parts. Instead, just use
libraries. If you want to have a single library made up of components from
separate files, use `export`.

Parts were added because there was this idea that users wanted to write really
big libraries that spanned multiple files. In practice, it doesn't seem like
most users work that way. Libraries tend to be pretty small.

There are some codebases like dartjs and the core libraries where you have
really big, chunky libraries. Even there, it's not clear that `export` wouldn't
be sufficient.

Much of this seems to boil down to different people having different
conceptions of what a "library" means.

### Prefixes

According to Gilad, prefixes are weird. They're one of the only places in the
language where an identifier doesn't denote an object.

He would like them to be more structured, to be a reference to an object that
you can pass around. Of course, this naturally implies first-class libraries.

### Symbols

We never liked them. They are a premature optimization, they are confusing to
explain to users, and [reflectable][] shows that they aren't needed for
tree-shaking.

[reflectable]: https://github.com/dart-lang/reflectable

### Fields final by default

There are valid syntax worries, but Gilad would like fields to be final by
default. Even something as simple as `val` instead of `final` might help make
something like this more palatable.

### Remove `break`, `continue`, and labels in favor of non-local returns

The portion of the Dart team that comes from a Smalltalk background has long
missed non-local returns. The stated reason for not having them is that no one
knows how to efficiently compile them to a language like JS which lacks them.

If our focus is moving off the web towards execution environments we control,
Gilad would like to put them back on the table. That would let us get rid of
`break`, `continue` and labels, at the expense of making it hard to break out
of a portion of a method.

However, losing those adds a pretty big unfamiliarity tax. Non-local returns
aren't well known. Scala and Ruby have them and they are done so seamlessly
that most users aren't even really aware of them, which speaks well to their
learnability. But those languages are also farther off the beaten path than
Dart tries to be.

Gilad, of course, not keen on the beaten path to begin with. You can't innovate
if you don't break with tradition. Personally, I want to give users new cool
things, but it's still important to bring that innovation as close to home as
possible.

### Assert

I would like to remove `assert()` from the language. It's a wart that Dart
isn't expressive enough to define something like that at the library and
instead has to special case it as this magic function in the language spec.

Even C doesn't have to do that: you can write your own `assert()` in normal C
code. I'm not arguing that Dart needs a C-style preprocessor, but it would be
nice if it had enough basic capabilities that `assert()` and similar things
could be defined in user code.

### Uniformity of reference

Dart has representation independence now, meaning that fields are
interchangeable with getters and setters. What it lacks is "uniform reference".
They way you refer to a property is different from how you refer to a method.
In other words, there is a difference between a getter (no `()`) and a
no-argument method (`()` required).

Gilad would like to make the parentheses optional in an empty argument list. I
personally, don't think we should do that, but we ran out of time to discuss
this in detail.

### Removing `new`

Yes, it came up. But we didn't get much time to talk about it yet.
