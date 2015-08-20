Attendees: [Bob][], [Florian][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## Warning on duplicate unnamed libraries

**Background info:**

If you omit the `library` directive in a Dart library, its name is the empty
string. If you import (or export) two libraries that do this, now you have two
libraries with the "same" name, which causes a warning in Dart.

The duplicate library name warning exists to help you avoid cases where you
reference the same library from two paths whose URLs do not canonicalize
together. For example, if you have a test in your `foo` package that does:

```dart
import '../lib/foo.dart';
import 'package:foo/foo.dart';
```

You've imported `foo` twice, from different paths. That means you'll get two
copies of all of their static state, you may get surprising errors in checked
mode, all sorts of weird stuff.

The warning tries to let you know if this happened. But, in practice, this
problem is actually very rare. We have good guidelines for how to reference
libraries and strong package culture, so actual collisions are rare.

The name collisions that occur in practice are two totally unrelated libraries
that happened to both omit their `library` directive. In this case, the warning
is bogus anyway: they aren't the same library. And, of course, you can't blame
someone for wanting to omit the `library` directive since it doesn't do anything
particularly useful.

**End background**

A while back, we discussed removing the warning on duplicate library names *only
for unnamed libraries*. One of the analyzer folks asked about the status of
this. Gilad has discussed it previously with TC 52, and we don't think there's
anything contentious about it. Gilad will tweak the spec and we'll discuss it
with TC 52 in September.

We spent some time discussing whether this needs to be put behind an
experimental flag since it hasn't been officially approved by TC 52 yet, but
it's so trivial we don't think it's worth worrying about.

## Experimental feature flags

This brought the discussion to implementing not-yet-approved-by-TC-52 features
behind experimental flags. Should we have a single flag for "everything we've
accepted but hasn't been to TC 52 yet"?

The last time we discussed this, the plan was to put each DEP behind its own
feature flag. For example, allowing [`super` calls in mixins][34] should be
behind a ["supermixin" flag][flag].

[34]: https://github.com/dart-lang/dart_enhancement_proposals/issues/34
[flag]: https://github.com/dart-lang/sdk/issues/23770

Sometimes we've been a bit lax about hiding things behind flags. Today, the
main Dart implementations (the VM, dart2js, analyzer, and DDC) are all
maintained by the Dart team. There aren't major independent Dart implementations
in the wild yet. Given that, it's probably not worth worrying about. We don't
want to be too formal about our processes.

## Reflectable

Gilad has been working on his Dart book and spent some time trying out the new
[Reflectable][] package. He has it featured in the chapter on reflection and in
his tests he's found it works surprisingly well.

[reflectable]: https://github.com/dart-lang/reflectable

Right now, Reflectable's public API is a bit different from "dart:mirrors".
Should we try to move the two APIs to be more compatible? That would make it
easier for users to start using Reflectable by just swapping out some imports.

*Editor's note: Erik clarified that it's not possible to make Reflectable
perfectly follow "dart:mirrors". Reflectable requires each mirror system—each
subclass of `Reflectable`—provide its own `reflect()` method where
"dart:mirrors" exposes a single top-level function.*

We would have to be careful because changing "dart:mirrors" could be a breaking
change. We have always considered "dart:mirrors" to be unstable and subject to
change. But, in practice, users are relying on it and we can't break them
arbitrarily.

Reflectable was designed to have an API very similar to "dart:mirrors" already
so it may make sense to just try to get it closer to "dart:mirrors" instead of
changing the latter. On the other hand, the places where Reflectable's API
differs are generally improvements over "dart:mirrors".

Florian feels that any significant change to "dart:mirrors" would have to wait
until Dart 2.0.

One thing Gilad likes about the Reflectable API is that it doesn't use symbols
and just uses regular strings instead. He felt symbols were always a premature
optimization that was confusing to users of "dart:mirrors".

I asked if we have real-world customers using Reflectable yet. We have some
teams that are starting to look at it. The 1.0 port of Polymer to Dart uses
Reflectable. The Angular folks haven't looked at it yet because the Reflectable
transformers require resolution which makes them slower than the Angular folks
are comfortable with right now.

Right now, Angular is a big customer of Dart and they are acutely feeling pain
around reflection and metaprogramming. I would be hesitant to lock down an API
for something like Reflectable until we're confident it's a good fit for users
like them.

## Dart 2.0

We're just starting to discuss what a potential "Dart 2.0" could mean. How big
of a change would it encompass? How painful of a transition is acceptable? What
do we think the resulting language would look like?

Of course, we always want to minimize pain, but what is the acceptable
trade-off? How much pain is worth it to get to feature X? For all of these
questions, we'll get feedback from the user community to see how they feel.

Very early on, we decided 2.0 would have almost no breaking changes. We would
call it 2.0 officially because there may be some small breakages, but we'd do
our very best to not break most programs.

Since then, we've started thinking about being more ambitious. Should we
consider some more fundamental changes to the language? For example, Gilad would
be happy to see first-class libraries and metaclasses—features that would change
the flavor of the language.

What is the opportunity cost of *not* making ambitious changes like this? Today,
we feel that as a language we're OK, but we're not super-attractive. It could be
that we're too conservative and aren't getting the full benefits of owning our
own language.

But, doing ambitious changes like this takes real, significant engineering time.
It's a huge resource commitment to plan, design, experiment, implement, test,
and ship large language changes. It would take us as well as many others on the
team. Are we willing to do that? Kasper is leaning towards "yes" but it's not at
all decided.

If we do decide to put that time into it, we better solve some fundamental
issues and get some real value out of it.

Florian points out that many fundamental changes are actually less breaking than
"minor changes". In many cases, you can statically see the new feature, so tools
can help you fix your code. But, say, renaming the `add()` method on List would
be virtually impossible. It may end up that some of these fundamental issues may
be easier than library "clean-ups".

Kasper says doing this may make the language more "foreign" but may help us
stand out from the crowd more. I believe we may end up with something that
doesn't feel more foreign. Right now, we're straddling the line between
dynamically typed languages and statically typed ones. If we move in either
direction, we may pull out of the uncanny valley towards either a more familiar
Smalltalk/JS/Ruby dynamic style or a C++/Java/C# static style.

Obviously, we still have lots more to discuss here.

## Resources

The `Resource` API we are close to shipping doesn't seem to meet all of the use
cases we need it to. There's an alternative suggestion to add a dedicated syntax
for referring to a resource from code. This would us do things like reference a
resource at a path relative to the source file. On the other hand, it implies
that all resources used by a program have to be statically embedded in the code.

In practice, I don't think this will be useful. Users will want to write
middleware layers, resource managers and helper functions to work with resources
generically. Those won't be possible if you have to list all of your resources
statically in your code.

Florian says the currently-designed `Resource` class has similar problems
already. If we don't have many users who need this right now, maybe we should
drop this from the release. From talking to Natalie, the impression I get is
that it's not ready yet, so I'm in favor of postponing it until we have
something better.

Kasper points out that the pressing problems were trying to solve with resources
are still there and pushing off the Resource API leaves them unsolved. It's
still appealing to solve at least some of the problems if not all of them. Lars
wants the ability to detect at least some of the resources at compile time so
that they can be bundled up with the snapshot.

I look at it more as postponing it than killing it. Once we ship something in
the SDK, it *must* be stable so we cause ourselves a lot of pain if we ship
something where we aren't sure it's a great solution for our problems. One
option is to mark it experimental. That will let us get it out there to get
feedback while still letting us make changes.

Of course breaking even an experimental feature may still break users, which
can scare people away. It may be better to not ship at all.

## Iteration and velocity

Kasper thinks there's a larger lesson we need to learn here. It feels like we're
somehow rushing features and then when it reaches implementation things break
down. Then we get feedback and we have a hard time applying it. It feels like
that part of our process is broken. Our track record is not fantastic.

Gilad feels we have an "excess of velocity". We can't easily pull back a change,
so we should invest more time in design before we ship it. A good idea is to
implement things before announcing and standardizing them. We tend to rush
things to TC 52.

I agree. It's not that we need a slower waterfall, it's that we need more
iteration, experimentation and data gathering before a design is locked down. It
doesn't matter how slow you go. If you don't get good feedback, you aren't going
to do good design.

Florian notes that we have a very large corpus of internal code where we can
make sweeping changes. We should take advantage of this and try out features
there and prove our designs before we ship them.

Now that we're on Git, it's easy for us to develop on feature branches, which
gives us a natural path to merge or reject experimental implementations.
