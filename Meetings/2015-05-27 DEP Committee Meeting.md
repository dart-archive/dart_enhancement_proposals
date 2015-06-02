Attendees: [Bob][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

This week's meeting was a short one because I forgot about the Memorial
Holiday, thought Wednesday was Tuesday, and ended up showing up fifteen minutes
late. Sorry about that.

## [Non-nullable types and non-nullable by default][nnbd]

[nnbd]: https://github.com/dart-lang/dart_enhancement_proposals/issues/30

If you haven't seen it, [Patrice's proposal][dep] is a stellar example of what
a high quality DEP looks like. The whole committee hasn't read it in depth
yet&mdash;it's about 50 pages&mdash;but we're working our way through it and
filing issues or otherwise providing feedback.

[dep]: https://github.com/chalin/DEP-non-null

Gilad describes the proposal as, "fundamentally, this is doing it right".

The high level question is whether it's something we want to do at all. It is a
breaking change, of some sort. We do like that the proposal describes why and
how it's a breaking change, and how to mitigate that.

The question for us&mdash;for various definitions of "us"&mdash;is whether we
will be happy with where we end up if we go through that migration process. If
we think it's a worthwhile destination, we should start putting resources into
figuring out how to get there.

Historically, some people on the language team haven't been a fan of
non-nullable types. There's a worry that they add a lot of complexity to users
and you don't end up being able to avoid null anyway.

At the same time, we are seeing users pulling Dart in a direction where they
get more mileage out of their static types and non-nullable types might let us
do that without changing some of the fundamental structure of the system.

What impressed me about the proposal is how little change seems to be required
to get to a world where non-nullable types are the default. That leads me to
believe (and in the past I've gone through code to validate this) that most
Dart code today doesn't work with null values.

### Experimenting

In order to see if that impression is true, though, we'd have to implement the
type rules and see how real-world Dart code fares under them. We'd want to do
this without being actually committed to shipping it in the language. We'd have
to conduct it as an experiment first.

One concern is that nullable types end up being viral and spreading throughout
your program, landing you right back where you started. If you've ever tried to
make a large C++ program const-correct, you have an inkling of how this can go.

A piece that would help is a tool that can automate converting from
nullable-everywhere Dart code to the proposed non-nullable-by-default form and
add in the nullable annotations as needed. We could do this either statically,
or at runtime in checked mode, or maybe even both.

For change of this magnitude, there are a couple of gates it has to go through:

1. Does the proposal have enough value to be worth putting real Dart team
   resources into doing some experimental implementations so we can validate
   the model?

2. If that pans out, do we want to commit to shipping it in the language?

One initial step might be to add a flag to the VM to parse but ignore the
syntax so experimental code using the new annotations runs as-is in the VM.
Meanwhile, we can experiment with static analysis.

If we decide to back out, it would be pretty simple to have an analysis server
quick fix that just strips out the annotations.

### Syntax

Gilad is slightly worried about the `!` syntax since it looks like a negation.
I suggested maybe going postfix instead, but that may run into other collisions
with operators. We could do postfix `!` and prefix `?` but that might be
strange.

### Next steps

I'll just quote Gilad directly here: "No one, externally or even internally has
written something this outstanding. The proposal is really really good."

We like it, but the change is a big one.

There are two things to figure out:

1. Hammer out the little details around the syntax. The proposal makes good,
   concrete suggestions, but maybe we'll want to tweak them a bit.

2. Working together to put together a plan for how we could actually implement
   and run the experiment. And how to migrate the world if the experiment
   succeeds, or gracefully back out if we decide not to do it.

A lot of the second point involves us on the Dart team. Figuring out
if/when/who/how much time we can spend on it.

### Dart 2.0

If we do end up declaring a Dart 2.0 that has this, there is some
infrastructure in place to help. Pub already supports SDK constraints. This
lets a package declare that it requires a certain version of Dart itself. If
you haven't upgraded to that version of Dart yet, pub won't select that version
of that package.

This would help ensure users using Dart 1.x don't get broken by inadvertantly
upgrading to packages that require Dart 2.0 features.

Even though most existing Dart 1.x code would work in Dart 2.0, the reverse
isn't true. Dart code using new syntax won't run on older VMs.

To mitigate that, one of the first steps for us might be to pin down a syntax
and have the VM's parser just ignore it instead of choking on it. We could do
that relatively soon so that by the time that syntax is useful, more users have
upgraded to a version of the VM that will at least ignore it (which is what the
semantics basically are in production mode anyway).

### More next steps

On our end, now, is the work to figure out what the consensus on the team is
for how valuable this change is. Compared to something like async/await,
actually implementing the proposal doesn't seem like that much work. Given that
much of the existing Dart code is already written such that it pretends null
doesn't exist, it doesn't even seem like it changes the feel of the language
very much.

But it does push work onto our users where they would have to add annotations
in some cases. Making existing Dart users update their code is a very very
large cost. New warnings would appear in previously warning-free code.

So we have a lot of work to do to see how this fits into the larger Dart
ecosystem.

A few trailing anecdotes about non-nullable types:

* When Facebook announced their [Flow type checker](http://flowtype.org/) for
  JS, one of its biggest bullet point features was that it did null checking.

* Gilad's experience from Smalltalk was that null errors were the only type
  error that actually mattered.
