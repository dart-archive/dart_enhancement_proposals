Attendees: [Bob][], [Florian][], [Gilad][], [Kasper][].

[bob]: https://github.com/munificent
[florian]: https://github.com/floitschG
[gilad]: https://github.com/gbracha
[kasper]: https://github.com/kasperl

## Configuration-specific code

Based on my discussions last week, I wrote up [a proposal for interface
libraries][interface libraries] and sent that around to the analyzer folks and
the other stakeholders. It's ready for more feedback, so I'll file it as a DEP
and Gilad will take a look. There's still one section that needs filling in, and
I'm hoping to get some help with that. But otherwise, I think it's ready to be a
DEP.

[interface libraries]: https://github.com/munificent/dep-interface-libraries

The runtime semantics are *very* simple. You can practically implement it at
parse time. The static checking is optional and can then be layered on top of
that.

We'll plan to discuss the proposal in this meeting next week.

## [Assert messages][37]

[37]: https://github.com/dart-lang/dart_enhancement_proposals/issues/37

Lasse was working on implementing this in dart2js but ran into an issue, so he's
planning to hand that off to the dart2js team.

## DEP process

I suggested that I should update the [docs and flowchart][docs] to add an
explicit "doing experimental implementation" stage a proposal goes through
before being accepted. That lines up with the process we've verbally agreed to.
I just need to write it down.

[docs]: https://github.com/dart-lang/dart_enhancement_proposals

## [`const` functions][const]

[const]: https://github.com/yjbanov/dart-const-functions

There's been a lot of discussion about Yegor's proposal for adding the ability
to define functions that can be invoked in const expressions.

It's not a submitted DEP yet, but we brought it up to see if we want to be
involved in proactively guiding it.

Personally, I'm not a fan of `const` in general, so it's hard for me to get
excited about a proposal that builds on it. I feel that `const` doesn't provide
much value for the sizable complexity it adds. Making it more powerful would, I
think, wouldn't add enough value to really dig it out of that whole.

I think making `const` more powerful is a step along a slippery slope towards
ultimately having a separate language that's as expressive and complex as Dart
itself.

For possibly the first time in history, Gilad and I are in complete agreement.
Let the record note it.

I want to take a step back and look at what problems the Angular folks are
solving. I think it's natural for Angular and pretty much any framework to need
to let users add extra bits of declarative data to various constructs and then
be able to access and use that data at runtime.

Metadata annotations *seem* like the natural place to do that, but then you run
into the `const` limitation. That limitation makes some sense for when you want
to process metadata annotations at *compile time*. Thinks like transformers that
consume metadata annotations need to be able see what their values are without
running arbitrary Dart code.

But if you're using metadata annotations to embed data in the application that
really is part of program and is being used at runtime, there's no need to limit
it to `const`. You're running Dart code at that point, so arbitrary expressions
could be allowed.

One possible solution would be to simply allow arbitrary expressions in metadata
annotations. Some *tools*, like Angular's transformer, that consumes annotations
at compile time may place restrictions on what kinds of expressions are allowed
in the annotations *it* cares about. But the language itself wouldn't
premptively limit *all* annotations in that way.

Or we could add some other separate kind of metadata annotation that is
lazily-evaluated at runtime.

These may play nice with [Reflectable][] it what we need is effectively a big
map of data keyed by some declaration. In some cases&mdash;classes and
functions&mdash;the declaration is already first class.

[reflectable]: https://github.com/dart-lang/reflectable

I'm not sure if the `const` function proposal is a good solution, but it does, I
think highlight a real problem in Dart where it isn't very framework friendly.
For now, our plan is to see how the proposal matures and try to get a better
understanding of what use cases and problems it addresses.
