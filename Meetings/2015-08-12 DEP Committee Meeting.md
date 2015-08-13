Attendees: [Bob][], [Florian][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

This was our first meeting back after the July break. (Well, second, but I
missed the first one.) Florian will be joining us at the meetings from now on.

### [#34 Allowing `super()` calls in mixins][34]

[34]: https://github.com/dart-lang/dart_enhancement_proposals/issues/34

Florian has a few concerns with the proposal as it stands. First, it prevents
us from adding a warning that would be useful in many cases.

#### Warning on known bad super calls

Consider:

```dart
abstract class Requirement {
  // The mixin class wants to see a 'foo' on its superclass.
  foo();
}

// Mixin intercepts 'foo'.
class Mixin extends Requirement {
  foo() => super.foo() + 1; // <--
}
```

Here, we know statically that that `super.foo()` call is going to call an
abstract method and fail. It would be nice to change Dart to show a warning
here. But, if we fix that, then this breaks the case where `Mixin` is used as a
mixin:

```dart
class Base implements Requirement {
  foo() { ... }
}

class Derived extends Base with Mixin {}
```

Here, that `super.foo()` call will now work because *when `Mixin` is mixed in*,
its new superclass does have a concrete `foo()` method. So this proposal
prevents us from adding that warning.

There is also a reverse problem:

```dart
abstract class Incomplete implements Requirement {}

class Derived extends Incomplete with Mixin {}
```

Here, we *should* warn because the `super.foo()` call in `Mixin` will fail.

#### Mixing in a class with superclasses does not mix in the superclasses

This is the similar to a problem that [Siggy filed an issue for][issue].
Consider:

[issue]: https://github.com/gbracha/lessRestrictedMixins/issues/2

```dart
class Mixin1 {
  get a => 1;
}

class Mixin2 extends Mixin1 {
  get b => 2;
}

class Foo extends Object with Mixin2 {}
```

Users may intuit that `Foo` will inherit both `a` and `b` since they are mixing
in from a class `Mixin2`, that contains both of those. However, the `extends`
clause of `Mixin2` is ignored when it gets mixed in. (Informally, when you
mixin a class, you only get the stuff "inside its own curlies".)

#### Mixins with constructors

Florian brought up the annoyance that you cannot use a class as a mixin if it
declares a constructor. He sketched out an alternative proposal to address
these but eventually decided he wasn't happy with that either.

Kasper said the limitation on constructors is well known and that there is an
eventual solution we have in mind. We haven't done it yet to keep things simple
initially. Our goal is to enable as many use cases as possible while avoiding
this complexity.

#### Constructors and `super implements`

Florian suggested that if we take my idea on Siggy's issue about `super
implements` then the constructor goes away. The idea is that when you mix in a
class, you ignore its constructors (and superclasses). You only mix in its
methods. Any `super` calls in those methods are type-checked based on the
`super implements` clause the class declares.

Kasper said that if we think we will eventually do the full solution, then this
problem with constructors will go away then. In that case, why worry about it
now?

Gilad is worried that if we try to partially solve it now, that solution may
clash with what we end up wanting to do later.

### Longer meeting

We talked a bit about whether we want to change or augment the time and
structure of this meeting. It feels like 30 minutes isn't enough to really
discuss an issue in depth.

This raises a question of what the scope of these meetings is. Is it just to
run through the open DEPs, see what consensus there is and update their status?
Or is it also to do actual language design and discussion?

Technically, it's only the former, but it seems like we could use more time for
the latter. Much of the design process happens in text—mailing lists,
documents, proposal repos, etc.—but actual real-time meetings have higher
bandwidth and can be useful too.

No real decision on this, but we'll discuss it more over email.

### Eliding `const`

Lasse has a [draft proposal for not requiring `const` in many places][const].
We've talked about it a few times before but tabled it because it isn't a
pressing issue. Florian brought it up because he's interested in it and to get
our feelings on it.

[const]: https://github.com/lrhn/dep-const

My feeling is that the proposal is good, but I wonder if it will make us wish
we could elide `new` as well. (Whether that in turn is a good thing or not is
an open question.)

Gilad still has reservations about context determining how a piece of code is
interpreted.

Kasper raised a concern that applying this to default values would make it hard
to later support non-`const` default values. My feeling is that we shouldn't do
those *anyway*—it's a notorious footgun in Python—so there's no loss there.
Kasper said this is the only thing that worries him about the proposal, and
noted that there is precedence for this in metadata annotations.

Personally, I like how this proposal rationalizes metadata annotations in a way
that makes them *not* special by not requiring `const`—they are just
another `const` context.

But, Gilad notes, if we go down this path, it does mean we won't be able to go
back. Once we declare things as `const` contexts, we won't be able to loosen
them later to allow non-`const` constructs.

None of this affects the higher level question of priority. The last time Gilad
discussed proposals with Lars, this was one of the ones that ended up in the
"not a priority right now" bucket. We don't know if it should leave that bucket
or not.

Either way, Florian will talk to Lasse about default values and see what his
thoughts there are.

### Making named parameters mandatory unless they have a default value

Florian wanted to talk about the idea of making a named parameter required if
it doesn't specify a default value. This would let a method rely on having the
parameter be present (instead of having to check this in the body) while
getting the readability benefits of a named parameter. For example, we
encourage boolean parameters to be named, but many of those really are
required.

Personally, I can see the utility, but I worry that parameter lists are already
so complex that it's hard to jam more features in there without ending up
sacrificing usability. I don't know if I think this feature is useful *enough*
to justify.

Kasper suggested that in many of these places you should just define an enum
instead of a boolean flag and then you don't need the parameter to be named.
There are some drawbacks to that, though. It may be more tedious to define the
enum than is worth.

Florian's feeling is that even though this isn't a necessary feature, it
addresses a pain point he runs into frequently.
