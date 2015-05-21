Attendees: [Bob][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## [#28 Static analysis of calls on functions][28]

[28]: https://github.com/dart-lang/dart_enhancement_proposals/issues/28

We're fine with it. There's still some spec work to do. The easy stuff is
there. There's a few more things that aren't there yet. Gilad will help out.

Basically, we'll reinterpret `Function` as a magical type that describes all
function types.

## The `const` brothers

There are two DEPs out related to `const`. They haven't been officially sent to
the committee yet, but people are talking about them on core-dev@.

* Rasmus Eneman has a proposal for [constant function literals](https://groups.google.com/a/dartlang.org/forum/#!topic/core-dev/W9zZt9T4ciA)
* Lasse has a proposal for [eliding `const` inside const expressions](https://groups.google.com/a/dartlang.org/forum/#!topic/core-dev/It2sBgpdIG8)

I guess us looking about them now is jumping the gun, but why not?

### Constant function literals

The main problem with allowing constant anonymous functions is that they cannot
be closures over non-constant state. Rasmus addresses that by saying they are
sugar for *top-level* functions.

This ensures they aren't closures since they only have access to top-level
scope. Doing this would probably work, but we think it will be confusing for
users. For example:

```dart
var a = "outer";

main() {
  var a = "inner";
  var f = const () { print(a); };
  f();
}
```

Assuming I understand the proposal correctly, this would print `"outer"` and
not have any errors. This would probably be unpleasantly surprising.

The function is at least clearly marked `const` so there's a way to see where
this behavior is occurring. Of course, if we mix this with Lasse's proposal,
that becomes no longer the case.

We aren't sure if this is something we want to rush into. If it is something we
want to do, we probably want something more complex than just saying it's in
the top level scope. We would probably want to say it is in the scope where it
appears, but closing over anything is some kind of error.

### Eliding `const`

One of the things that users have repeatedly been annoyed by is the need to
repeat `const` at every level of a constant expression. This code is wrong:

```dart
const data = const [
  {
    "widgets": [const Widget(1)]
  }
]
```

It has to be:

```dart
const data = const [
  const {
    "widgets": const [const Widget(1)]
  }
]
```

Lasse's proposal defines a "const context". Inside that, the keyword `const`
can be left out. Metadata annotations, constant initializers, and default
values are all const contexts, so the above can be:

```dart
const data = [
  {
    "widgets": [Widget(1)]
  }
]
```

This regularizes the special case where `const` can be omitted for the
outermost constructor call of a metadata annotation.

Gilad is generally against the idea of the same program text meaning something
different in different contexts. He also brought up that this can make some
code related to generics ambiguous. By leaving off the `new` or `const` in a
constructor call, code like this:

```dart
@A(B<b,c>d())
```

Could interpreted in one of two ways:

```dart
@A(B<b, c>d())     // Call constructor on generic class B, pass to A.
@A(B < b, c > d()) // Call constructor on A, passing two arguments.
```

The [generic method proposal][gen] has the same problem. It is a breaking
change, but it's unlikely to occur in practice.

[gen]: https://github.com/dart-lang/dart_enhancement_proposals/issues/22

If we decide it's a direction we'll go in, we can start making our tools like
the analyzer warn on this construct now to give people time to migrate.

## [#26 Full optional parameters][26]

[26]: https://github.com/dart-lang/dart_enhancement_proposals/issues/26

Gilad filed an issue that Lasse hasn't addressed yet to add some more spec
details to the proposal.

We're also waiting for feedback from the DDC folks to see how feasible they
think it will be to implement this. So for now, we'll just kick it down the
road.

## Mixins

Not a DEP yet but Gilad wanted to start talking about this. He initially
planned to resurrect his original proposal for mixins that didn't have the
restrictions of the current language around `super()` calls and constructors.

Since then, there has been some discussion about another way to enable checking
`super()` calls. You could basically define the "superclass interface" for a
mixin class.

`super()` calls within the class would be checked against that interface. When
the class is mixed in to another, we could check that that class's superclass
also satisfies the interface.

This might give us an easier path forward than doing the whole kit and
caboodle. We're worried doing everything might take too long to implement.

Kasper brought up that this takes us a step towards making mixins separate
constructs from classes. Specifying a superclass interface means that the class
is intended to only be used as a mixin. We're not sure if we want to move away
from having everything&mdash;interfaces, classes, and mixins&mdash;unified
under a single construct.

Part of the problem is that a class definition creates two things and
associates them with the same name:

1. The full class with all of its inherited members. This is what you get when
   you use it as a class or an interface.

2. The "delta" between this class and its superclass. In other words, just the
   members it itself defines. This is what you get when you use it as a mixin.

People have to be aware of this distinction and understand which of the two
they're getting where. Allowing mixins to have non-`Object` superclasses might
make that more confusing.

One idea Gilad had is to allow a mixin to have a superclass and/or
superinterfaces. When you mix it in to another class, we could warn if the
latter's superclass doesn't implement the mixin's superclass and
superinterfaces.

This would let users know they got #2 when they may think they got #1. It would
get us a step closer to the full solution.

Gilad will look into formulating a DEP for this.
